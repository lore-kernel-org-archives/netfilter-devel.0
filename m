From: Nigel Kukard <nkukard@lbsd.net>
Subject: Re: [PATCH] New match module: byte rate match
Date: Tue, 21 Jan 2003 12:38:36 +0200 (SAST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0301211236040.13452-100000@mail.lbsd.net>
References: <Pine.LNX.4.44.0301161438250.2232-100000@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Chris Wilson <chris@netservers.co.uk>
In-Reply-To: <Pine.LNX.4.44.0301161438250.2232-100000@localhost>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


There is already a match like this, maintained by LBSD  (www.lbsd.net)
and can be found at   ftp://www.lbsd.net

This patch was rejected because it was said to be a copy of ipt_limit.

good luck!


On Mon, 20 Jan 2003, Chris Wilson wrote:

> Hi all,
> 
> NetServers.co.uk would like to submit a new module for your perusal and
> hopefully for inclusion in Netfilter. It's based on ipt_limit, but matches
> the number of bytes per second instead of the number of packets. This
> means that it can be used for basic quality-of-service implementation,
> thus:
> 
> # limit SMTP traffic from A to B to 4kbytes/s
> iptables -A FORWARD -s A -d B -p tcp --dport 25 -m bytelimit --limit 
> 	4000/s -j ACCEPT
> iptables -A FORWARD -s A -d B -p tcp --dport 25 -j DROP
> 
> # classify the first 8kbytes/s of SSH traffic as high priority
> iptables -t mangle -A FORWARD -p tcp --dport 22 -m bytelimit --limit
>         8000/s -j TOS --set-tos minimize-delay
> iptables -t mangle -A FORWARD -p tcp --dport 22 -j TOS --set-tos normal
> 
> You can download the patches against iptables-1.2.7a userspace and kernel
> 2.4.19 here:
> 
>   'http://www.netservers.co.uk/gpl/iptables-bytelimit-030116.tar.gz'
> 
> And more information about us, including other GPL software, here:
> 
>   'http://www.netservers.co.uk/gpl/'
> 
> The module is licensed under the GPL, as it is based on ipt_limit. At this
> stage, the module is only lightly tested, but it works for us. We hope it
> will be useful to someone. 
> 
> Cheers, Chris.
> 

-- 


Nigel Kukard  (Chief Executive Officer)
Lando Technologies Africa (Pty) Ltd
nigel@lando.co.za   www.lando.co.za
Tel: 083 399 5822  Fax: 086 1100036
Hoheisen Park Bellville,  Cape Town
National  Internet Service Provider


  The best language to use is the language that was designed for
         what you want to use it for - 1997


=====================================================================

Disclaimer
----------
The contents of this message and any attachments are intended 
solely for the addressee's use and may be legally privileged and/or 
confidential information. This message may not be retained, 
distributed, copied or used if you are not he addressee of this 
message. If this message was sent to you in error, please notify 
the sender immediately by reply e-mail and then destroy the message 
and any copies thereof.

Opinions, conclusions and other information in this message may be 
personal to the sender and is not that of Lando Technologies Africa 
or any of it's subsideries, associated companies or principals and 
is therefore not endorsed by any of the Lando groups of companies. 
Due to e-maill communication being insecure, Lando groups of 
companies do not guarantee confidentiality, security, accuracy or  
performance of the e-mail. Any liability for viruses is excluded 
to the fullest extent.
