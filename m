From: "Leonid Zeitlin" <lz@csltd.com.ua>
Subject: Re: Invalid SACK numbers in NAT'ed packets
Date: Fri, 25 Apr 2008 14:24:32 +0300
Message-ID: <015701c8a6c6$ef5d6570$5101a8c0@csltd.intranet>
References: <funk78$srq$1@ger.gmane.org> <Pine.LNX.4.64.0804232126040.28881@blackhole.kfki.hu> <00c101c8a5ea$d83213f0$5101a8c0@csltd.intranet> <Pine.LNX.4.64.0804241130040.30382@blackhole.kfki.hu> <006b01c8a6b1$884da030$5101a8c0@csltd.intranet> <Pine.LNX.4.64.0804251059510.5340@blackhole.kfki.hu> <alpine.LNX.1.10.0804251256530.11644@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Cc: <netfilter@vger.kernel.org>, <netfilter-devel@vger.kernel.org>
To: "Jan Engelhardt" <jengelh@computergmbh.de>,
	"Jozsef Kadlecsik" <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

If I am reading the news correctly, it is available in the latest 2.6.25 
kernel, right?

Thanks,
  Leonid


----- Original Message ----- 
From: "Jan Engelhardt" <jengelh@computergmbh.de>
To: "Jozsef Kadlecsik" <kadlec@blackhole.kfki.hu>
Cc: "Leonid Zeitlin" <lz@csltd.com.ua>; <netfilter@vger.kernel.org>; 
<netfilter-devel@vger.kernel.org>
Sent: Friday, April 25, 2008 1:57 PM
Subject: Re: Invalid SACK numbers in NAT'ed packets


>
> On Friday 2008-04-25 11:02, Jozsef Kadlecsik wrote:
>
>>On Fri, 25 Apr 2008, Leonid Zeitlin wrote:
>>
>>> It appears that short of writing a custom netfilter extension, there's 
>>> no way
>>> to turn off SACKs on a particular connection. Is this right?
>>
>>Yes, exactly. Actually, writing a new extension to erase any TCP option
>>isn't that hard: just replace the option with noop and recalculate the
>>checksum.
>
> There is already a TCPOPTSTRIP target.
> 

