From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Iptable Extension Arg question
Date: Fri, 12 Mar 2004 08:19:13 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403120811330.29532-100000@filer.marasystems.com>
References: <Pine.LNX.4.44.0403111655320.13639-100000@lhotse.up.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: John Fastabend <jfastabe@up.edu>
In-Reply-To: <Pine.LNX.4.44.0403111655320.13639-100000@lhotse.up.edu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 11 Mar 2004, John Fastabend wrote:

> 1) on line 92 of libipt_TOS.c where it says
> 	struct ipt_tos_target_info *tosinfo = 
> 		(struct ipt_tos_target_info *)(*target)->data;
>   
>    does this mean that the args from the command line are stored in 
> target->data?

Yes, or more precicely that the pointer to the target specific argument 
structure is.

> And if so does that mean I will have to pass the args another way if I
> am trying to pass a couple ip addresses which would be longer then data
> which is an unsigned char. i think.

No. Each target defines its argument structure. Can be of any size.

> 2) what does the struct option opts[] on line 50 do? Its used in the 
> iptables_target 
> struct below, but where does it show up in the module code?

It defines the command line arguments understood by the target specific 
userspace module used by the iptables command to translate your command 
line into the required kernel structure.

> 3) finally how do the args get used in ipt_TOS.c, it looks to me that they 
> are passed in through targinfo. so maybe the above questions will show me 
> how to get the arguments into targinfo.

It is.

> If the args are in targinfo what is the userinfo pointer for?

userinfo is not used and can be ignored.


There is also some information on how this works on the general level in
the netfilter hacking howto document, but reading the source of a couple
of targets provides more detail than the howto.

> ps if this is the wrong list for this type of question just ignore it.

It is 100% the correct list for this type of question.

Regards
Henrik
