From: Patrick McHardy <kaber@trash.net>
Subject: Re: BUG: More ipt_recent queries
Date: Sat, 04 Mar 2006 11:13:22 +0100
Message-ID: <44096842.3010507@trash.net>
References: <dt51lh$b63$1@sea.gmane.org> <43FAF692.8030804@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: sfrost@snowman.net, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
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

Stephen, can you have a look at this please?

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
> 
> Sam
> 
> 
