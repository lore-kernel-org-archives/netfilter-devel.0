From: Emmanuel Guiton <emmanuel@netlab.hut.fi>
Subject: Re: Counter problem in a new nat target.
Date: Wed, 10 Dec 2003 13:00:05 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FD6FCB5.20205@netlab.hut.fi>
References: <Pine.LNX.4.44.0312091107570.24092-100000@filer.marasystems.com> <3FD6DAE8.5040205@deansoft.com.tw>
Reply-To: emmanuel@netlab.hut.fi
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jesse Peng <jesse@deansoft.com.tw>,
        Henrik Nordstrom
 <hno@marasystems.com>,
        KOVACS Krisztian <hidden@balabit.hu>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

>
> 1.You maintain a hash struture which list any of your concerning 
> conntrack, and while a conntrack facing destroyed then looking  up 
> this hash list if it is on the list.
> 2.I don't think you need any real helper no matter how simple it can 
> be.But just to extend your target module while matching ip_ct_new put 
> some flags in the help 
> information(conntrack->help.Your_patched_private_help_info)indecate 
> that this is the conntrack you care. And then while a conntrack facing 
> destroyed then looking  up its help info if it is flaged. But if the 
> traffic you wanna filter overlaps with other helpers(eg. 
> ip_conntrack_ftp),then a somewhat dirty way regarding where you put 
> your flags(because help info is only for one helper)is to put them in 
> conntrack->nat.help.Your_patched_private_help_info(for this is 
> relatively a virgin place seldom touched by famous helpers except as I 
> know the pptp helper)
>
> But no matter which above you choose, You can't avoid patching your 
> private destroying code like how ip_conntrack_destroyed(destroying 
> code for NATed conntrack) been called.Because so far we never see any 
> extending conntrack destroying machenism concerning helper's private 
> functionality(like helper->destroy).
> Hope this can help ;)!
>
> Regards
> Jesse


I think the conntrack->help data can be very useful to identify the 
counter to which the conntack belongs. that's a good idea, thanks.

However, the counters' "storage place" is still an unsolved issue. The 
main function that uses these counters is my nat target function. Only 
the decrease operation cannot be performed in this function. As Jesse 
and Krisztian metioned, I see so far two possibilities to decrease the 
counter:
 - in nat's ip_conntrack_destroyed
 - in a function in a struct notifier_block called upon the receipt of 
an IPCT_DESTROY notifier.
These two possibilities only offer to modify the conntrack structure, 
which does not work in my case.The counters are used to count the number 
of conntrack and the information in one conntrack is not related to the 
information in another conntrack.
In my target function, as Henrik pointed out, I can - easily, for want 
of cleanly - modify my counters in they are in the user data. In fact, I 
had originally placed the counters there, so that they were initialized 
when adding a new rule in the nat table.
Thus, if I could get a pointer to this user data when decreasinging my 
counters, the problem would be solved. I don't think it really fits in 
the ip_conntrack_destroyed function but why not in the notifier 
function? What about modifying the conntrack notifier system so that it 
includes also a pointer to the user data, or then make a brand new 
notifier system (because at first sight I don't see how to include a 
pointer to the user data in the current conntrack notifier system)?

What do you think about that?

             Emmanuel

PS: thanks for your comments, it's very precious help.
