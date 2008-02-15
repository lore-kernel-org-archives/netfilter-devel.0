From: justin joseph <justin.cok@gmail.com>
Subject: Re: bug in iptables
Date: Fri, 15 Feb 2008 12:20:43 +0530
Message-ID: <47B53643.9000107@gmail.com>
References: <74d7e2880802141038t53e58f5frafe12a3a77a3fca9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail19j.g19.rapidsite.net ([204.202.242.58]:27795 "HELO
	mail19j.g19.rapidsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753833AbYBOG5r (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Feb 2008 01:57:47 -0500
Received: from mx122.stngva01.us.mxservers.net (198.173.112.51)
	by mail19j.g19.rapidsite.net (RS ver 1.0.95vs) with SMTP id 0-0460178265
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Feb 2008 01:51:06 -0500 (EST)
In-Reply-To: <74d7e2880802141038t53e58f5frafe12a3a77a3fca9@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



justin joseph wrote:
> Hi,


> It seems to be there in iptables as well.

To be specific I am able to add a rule thus:

iptables -t mangle -A tcpost -i lan1 -s 192.168.10.10 -o wan1 -p tcp --dport 22 -j CLASSIFY 
--set-class 1:11

Relevant "shorewall show mangle" output is:



Chain tcpost (1 references)
  pkts bytes target     prot opt in     out     source               destination
     0     0 CLASSIFY   tcp  --  lan1   wan1    192.168.10.10        0.0.0.0/0           tcp dpt:22 
CLASSIFY set 1:11
     0     0 CLASSIFY   all  --  *      wan1    0.0.0.0/0            0.0.0.0/0           MARK match 
0x1/0xff CLASSIFY set 1:11
     0     0 CLASSIFY   all  --  *      wan1    0.0.0.0/0            0.0.0.0/0           MARK match 
0xfe/0xff CLASSIFY set 1:1254


Man iptables says:

-i, --in-interface [!] name
Name of an interface via which a packet was received (only for packets entering the 
INPUT, FORWARD and PREROUTING chains).  When the "!" argument is used before  the  interface
name,  the  sense  is  inverted.  If the interface name ends in a "+", then any interface which 
begins with this name will match.  If this option is omitted, any interface name will match.

But iptables is taking the -i option in case of POSTROUTING as well.  In my case, I were trying to 
classify traffic coming from lan1:192.168.10.10 and although this rule was taken it was not being
hit because I understand from what Tom Eastep said, "It is because packets in the Postrouting chain 
are not guaranteed to even have an input chain"

-justin
