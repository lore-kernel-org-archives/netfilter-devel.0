From: John Fastabend <jfastabe@up.edu>
Subject: Iptable Extension Arg question
Date: Thu, 11 Mar 2004 17:13:57 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403111655320.13639-100000@lhotse.up.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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

hi,

im new to netfilter and trying to figure out how to pass arguments to a 
target extension module.  Im using the TOS target extension as sample code 
but I have a few questions.

1) on line 92 of libipt_TOS.c where it says
	struct ipt_tos_target_info *tosinfo = 
		(struct ipt_tos_target_info *)(*target)->data;
  
   does this mean that the args from the command line are stored in 
target->data? And if so does that mean I will have to pass the args 
another way if I am trying to pass a couple ip addresses which would be 
longer then data which is an unsigned char. i think.

2) what does the struct option opts[] on line 50 do? Its used in the 
iptables_target 
struct below, but where does it show up in the module code?

3) finally how do the args get used in ipt_TOS.c, it looks to me that they 
are passed in through targinfo. so maybe the above questions will show me 
how to get the arguments into targinfo. If the args are in targinfo what 
is the userinfo pointer for? 

If you can't tell im basicly confused abuot the whole thing. This is 
probably a lot to answer in one email so any help would be appreciated. 

thanks for your time,
john

ps if this is the wrong list for this type of question just ignore it.
 

-- 
--
"Dependence on computers is apparently making a significant fraction
of the population incurably stupid." -- Fritz Whittington
