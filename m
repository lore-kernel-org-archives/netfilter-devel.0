From: Amin Azez <azez@ufomechanic.net>
Subject: Re: BUG: More ipt_recent queries
Date: Tue, 21 Feb 2006 16:28:17 +0000
Message-ID: <43FB3FA1.7020808@ufomechanic.net>
References: <dt51lh$b63$1@sea.gmane.org> <43FAF692.8030804@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <43FAF692.8030804@ufomechanic.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Amin Azez wrote:
> I'm concerned about ipt_recent where it removes entries from the list.
> 
> Surly the move-up-and-close-the-gap while loop will never enter because 
> time_info[time_loc].time has just been set to 0 so that this clause of 
> the while loop:
> 
>   time_info[(time_loc+1) % ip_list_tot].time < time_info[time_loc].time)
> 
> will always be false.
> 
> Fuller code segment:
> 
> location = hash_table[hash_result];
> hash_table[r_list[location].hash_entry] = -1;
> time_loc = r_list[location].time_pos;
> time_info[time_loc].time = 0;
> time_info[time_loc].position = location;
> 
> while((time_info[(time_loc+1) % ip_list_tot].time <
> time_info[time_loc].time) && ((time_loc+1) % ip_list_tot) !=
> curr_table->time_pos) {
>   time_temp = time_info[time_loc].time;
>   time_info[time_loc].time = time_info[(time_loc+1)%ip_list_tot].time;
>   time_info[(time_loc+1)%ip_list_tot].time = time_temp;
>   time_temp = time_info[time_loc].position;
>   time_info[time_loc].position =
>              time_info[(time_loc+1)%ip_list_tot].position;
>   time_info[(time_loc+1)%ip_list_tot].position = time_temp;
>   r_list[time_info[time_loc].position].time_pos = time_loc;
>   r_list[time_info[(time_loc+1)%ip_list_tot].position].time_pos =
>              (time_loc+1)%ip_list_tot;
>   time_loc = (time_loc+1) % ip_list_tot;
> }
> 
> 
> I think we should set time_info[time_loc].time = 0; at the end of the 
> while loop?

This is actually solvable by changeing the while loop condition:
while(((time_loc+1) % ip_list_tot) != curr_table->time_pos) {
...

But appears also to have another problem which is that 
curr_table->time_pos should be decreased (mod ip_list_tot of course) to 
take into account that the last item in the newly shuffled time_info is 
now vacant; otherwise this test:

for I in `seq 1 100` ; \
do echo ${S}1.1.1.$I  > /proc/net/ipt_recent/LIMIT5 ; \
done ; \
echo -1.1.1.5 > /proc/net/ipt_recent/LIMIT5 ; \
echo 1.1.1.200 > /proc/net/ipt_recent/LIMIT5

Leaves 99 values instead of 100 because the slot from 1.1.1.5 was not 
re-used.

Inserting this line after the end of the while loop:
 
curr_table->time_pos=(curr_table->time_pos+ip_list_tot-1)%ip_list_tot;


solves the problem and causes shuffled-to-the-end spare slots in 
time_info to be re-used first. A side effect is that output of 
/proc/net/ipt_recent/* doesn't come out in time order any more; if there 
have been mid-list deletes and then further adds.

We could fix this by having ip_recent_get_info iterate indirectly using 
curr_table->time_info instead of curr_table->table.

Comments?

I guess I'll send one big patch when I get it all closed off.

Sam
