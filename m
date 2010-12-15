From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: ipset v5.0-pre10
Date: Wed, 15 Dec 2010 23:46:34 +0000
Message-ID: <4D09535A.7090006@googlemail.com>
References: <4D08D0A6.4020900@googlemail.com> <alpine.DEB.2.00.1012152121160.5033@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57681 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080Ab0LOXqn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Dec 2010 18:46:43 -0500
Received: by wyb28 with SMTP id 28so1999558wyb.19
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Dec 2010 15:46:42 -0800 (PST)
In-Reply-To: <alpine.DEB.2.00.1012152121160.5033@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> I don't completely understand you: the bitmap:port type already supports 
> adding/deleting port ranges. Could you write a full example?
>   
OK, here goes (*full* example using bash script):- Suppose that I need 
to define a pair of IP subnets with two range of ports - 
223.240.0.0/13:1-1024 and 223.248.13.0/24:8000-16000 - and include them 
in one set. In 4.x that will only be possible by using the following 
shell script (9 subsets as 4.x ipporthash construct accepts only /16 
subnets):
=======4.x===============
#!/bin/sh

cn_base_set='blacklisted-cn-240-special'
# initialise the new sets
for (( _i=0; _i < 8; _i++ )); do
# - split in 8 subsets as 4.x can't have more than /16 (B-class) subnets 
in ipporthash constructs
  ipset -N $cn_base_set$_i ipporthash --network 223.24$_i.0.0/16
done
ipset -N blacklisted-cn-248-selected ipporthash --network 223.248.13.0/24

for (( _i=1; _i <= 1024; _i++ )); do
# 1'st loop - low port ranges
  for (( _j=0; _j < 8; _j++ )); do
  # 2nd loop -24x /16 subnets
    ipset -A blacklisted-cn-240-special$_j 223.24$_j.0.0/16,$_i
  done
done
for (( _i=8000; _i <= 16000; _i++ )); do
# 2nd set - selected (8k-16k) port ranges
  ipset -A blacklisted-cn-248-selected 223.248.13.0/24,$_i
done
=========================

The above script will create 9 sets of type ipporthash: 
blacklisted-cn-240-special0 ... blacklisted-cn-240-special7 and 
blacklisted-cn-248-selected and then add the port ranges in the 
following manner:

ipset -A blacklisted-cn-240-special0 223.240.0.0/16,1
ipset -A blacklisted-cn-240-special1 223.241.0.0/16,1
...
ipset -A blacklisted-cn-240-special7 223.247.0.0/16,1
...
...
ipset -A blacklisted-cn-240-special7 223.247.0.0/16,1024

and then (last loop):

ipset -A blacklisted-cn-248-selected 223.248.13.0/24,8000
ipset -A blacklisted-cn-248-selected 223.248.13.0/24,8001
...
ipset -A blacklisted-cn-248-selected 223.248.13.0/24,16000

In 5.x-pre10 the above job would be a bit easier as I understand there 
is no limit on the size of the network (i.e. I am no longer constrained 
by B-class subnet):

=======5.x-pre10===============
#!/bin/sh

# initialise the new combined set
ipset -N blacklisted-cn-combined hash:ip,port

for (( _i=1; _i <= 1024; _i++ )); do
# 1'st loop - low port ranges
  ipset add blacklisted-cn-combined 223.240.0.0/13,$_i
done
for (( _i=8000; _i <= 16000; _i++ )); do
# 2nd set - selected (8k-16k) port ranges
  ipset add blacklisted-cn-combined 223.248.13.0/24,$_i
done
=========================

The above scripts will execute at least 9024 "ipset -A/add" statements!

It would be more convenient if I could do this in 5.x:

ipset -N blacklisted-cn-combined hash:ip,port
ipset -A blacklisted-cn-combined 223.240.0.0/13,1-1024
ipset -A blacklisted-cn-combined 223.248.13.0/24,8000-16000

Just 3 statements - much simpler and I won't bother with any loops!

