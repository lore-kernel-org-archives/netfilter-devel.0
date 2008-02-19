From: Patrick McHardy <kaber@trash.net>
Subject: Re: bug in iptables
Date: Tue, 19 Feb 2008 13:28:28 +0100
Message-ID: <47BACB6C.4090000@trash.net>
References: <74d7e2880802141038t53e58f5frafe12a3a77a3fca9@mail.gmail.com> <47B53643.9000107@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: justin joseph <justin.cok@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep18-int.chello.at ([213.46.255.22]:16005 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbYBSM2q (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Feb 2008 07:28:46 -0500
In-Reply-To: <47B53643.9000107@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

justin joseph wrote:
> 
> 
> justin joseph wrote:
>> Hi,
> 
> 
>> It seems to be there in iptables as well.
> 
> To be specific I am able to add a rule thus:
> 
> iptables -t mangle -A tcpost -i lan1 -s 192.168.10.10 -o wan1 -p tcp 
> --dport 22 -j CLASSIFY --set-class 1:11
> 
> Relevant "shorewall show mangle" output is:
> 
> 
> 
> Chain tcpost (1 references)
>  pkts bytes target     prot opt in     out     source               
> destination
>     0     0 CLASSIFY   tcp  --  lan1   wan1    192.168.10.10        
> 0.0.0.0/0           tcp dpt:22 CLASSIFY set 1:11
>     0     0 CLASSIFY   all  --  *      wan1    0.0.0.0/0            
> 0.0.0.0/0           MARK match 0x1/0xff CLASSIFY set 1:11
>     0     0 CLASSIFY   all  --  *      wan1    0.0.0.0/0            
> 0.0.0.0/0           MARK match 0xfe/0xff CLASSIFY set 1:1254
> 
> 
> Man iptables says:
> 
> -i, --in-interface [!] name
> Name of an interface via which a packet was received (only for packets 
> entering the INPUT, FORWARD and PREROUTING chains).  When the "!" 
> argument is used before  the  interface
> name,  the  sense  is  inverted.  If the interface name ends in a "+", 
> then any interface which begins with this name will match.  If this 
> option is omitted, any interface name will match.
> 
> But iptables is taking the -i option in case of POSTROUTING as well.  In 
> my case, I were trying to classify traffic coming from 
> lan1:192.168.10.10 and although this rule was taken it was not being
> hit because I understand from what Tom Eastep said, "It is because 
> packets in the Postrouting chain are not guaranteed to even have an 
> input chain"

Your example doesn't contain the rule jumping to "tcpost", so
its not clear whether this really is a bug. Please post all
four rules (tcpost and -j tcpost) and the kernel version you're
using.
