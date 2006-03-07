From: Amin Azez <azez@ufomechanic.net>
Subject: Re: BUG: More ipt_recent queries
Date: Tue, 07 Mar 2006 15:46:52 +0000
Message-ID: <440DAAEC.7060208@ufomechanic.net>
References: <dt51lh$b63$1@sea.gmane.org> <43FAF692.8030804@ufomechanic.net>
	<44096842.3010507@trash.net> <20060306030411.GZ4474@ns.snowman.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Stephen Frost <sfrost@snowman.net>
In-Reply-To: <20060306030411.GZ4474@ns.snowman.net>
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

As for the /proc output change, that was un-intentional, and for 
debugging purposes. I will remove that change, thanks for spotting it.

I'm just finishing testing on new options for ipt_recent, I hope to 
submit a full patch next week including Per's fix.

New options, from the man page:

       [!] --listcount-lt count
              Requires  as a precondition that the number of IP entries 
in the
              list (subject to the optional --listtime-*  specifier)  
is  less
              than  count  (or not !). No other options are considered 
if this
              is not true.

       [!] --listcount-le count
              Requires as a precondition that the number of IP entries 
in  the
              list  (subject  to  the optional --listtime-* specifier) 
is less
              than or equal to count (or not !). No other options are  
consid-
              ered if this is not true.

       [!] --listcount-eq count
              Requires  as a precondition that the number of IP entries 
in the
              list (subject to the optional --listtime-* specifier)  is  
equal
              to  (or not !) count. No other options are considered if 
this is
              not true.

       [!] --listcount-ge count
              Requires as a precondition that the number of IP entries 
in  the
              list (subject to the optional --listtime-* specifier) is 
greater
              than or equal to count (or not !). No other options are  
consid-
              ered if this is not true.

       [!] --listcount-gt count
              Requires  as a precondition that the number of IP entries 
in the
              list (subject to the optional --listtime-* specifier) is 
greater
              than  count  (or not !). No other options are considered 
if this
              is not true.

       Only one --listcount-* option can be specified.

       [!] --listtime-lt seconds
              Affects the --listcount-* so that instead of counting the 
number
              of  items  in  the list, it counts the number of items 
that were
              last updated less than seconds seconds ago.

       [!] --listtime-le seconds
              Affects the --listcount-* so that instead of counting the 
number
              of  items  in  the list, it counts the number of items 
that were
              last updated less than or equal to seconds seconds ago.

       [!] --listtime-ge seconds
              Affects the --listcount-* so that instead of counting the 
number
              of  items  in  the list, it counts the number of items 
that were
              last updated more than or equal to seconds seconds ago.

       [!] --listtime-gt seconds
              Affects the --listcount-* so that instead of counting the 
number
              of  items  in  the list, it counts the number of items 
that were
              last updated more than seconds seconds ago.

       Only one --listtime-* option can be specified. --listtime-* 
options act
              as select clauses for what to count. The ! negation for  
--list-
              time-*  options merely inverts the comparison, so ! 
--listime-le
              is the same as --listtime-gt

...

              The next example accepts the packet if less than 5 ip  
addresses
              in the list have been updated in the last 60 seconds

              #  iptables  -A FORWARD -m recent --listcount-lt 5 
--listtime-lt
              60 --set -j ACCEPT


Sam

Stephen Frost wrote:

>* Patrick McHardy (kaber@trash.net) wrote:
>  
>
>>Stephen, can you have a look at this please?
>>    
>>
>
>Alright.  I'll try to look over the current ipt_recent state and the
>comments I've seen regarding it.  I don't expect to have time to
>rewrite it anytime soon though.
>
>	Stephen
>
>  
>
>>Amin Azez wrote:
>>    
>>
>>>I'm concerned about ipt_recent where it removes entries from the list.
>>>
>>>Surly the move-up-and-close-the-gap while loop will never enter because
>>>time_info[time_loc].time has just been set to 0 so that this clause of
>>>the while loop:
>>>
>>>  time_info[(time_loc+1) % ip_list_tot].time < time_info[time_loc].time)
>>>
>>>will always be false.
>>>
>>>Fuller code segment:
>>>
>>>location = hash_table[hash_result];
>>>hash_table[r_list[location].hash_entry] = -1;
>>>time_loc = r_list[location].time_pos;
>>>time_info[time_loc].time = 0;
>>>time_info[time_loc].position = location;
>>>
>>>while((time_info[(time_loc+1) % ip_list_tot].time <
>>>time_info[time_loc].time) && ((time_loc+1) % ip_list_tot) !=
>>>curr_table->time_pos) {
>>>  time_temp = time_info[time_loc].time;
>>>  time_info[time_loc].time = time_info[(time_loc+1)%ip_list_tot].time;
>>>  time_info[(time_loc+1)%ip_list_tot].time = time_temp;
>>>  time_temp = time_info[time_loc].position;
>>>  time_info[time_loc].position =
>>>             time_info[(time_loc+1)%ip_list_tot].position;
>>>  time_info[(time_loc+1)%ip_list_tot].position = time_temp;
>>>  r_list[time_info[time_loc].position].time_pos = time_loc;
>>>  r_list[time_info[(time_loc+1)%ip_list_tot].position].time_pos =
>>>             (time_loc+1)%ip_list_tot;
>>>  time_loc = (time_loc+1) % ip_list_tot;
>>>}
>>>
>>>
>>>I think we should set time_info[time_loc].time = 0; at the end of the
>>>while loop?
>>>
>>>Sam
>>>
>>>
>>>      
>>>
