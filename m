From: Roberto Nibali <ratz@tac.ch>
Subject: Re: [PATCH] tcp window tracking patch with SACK support
Date: Wed, 06 Nov 2002 12:33:09 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3DC8FDF5.7050906@tac.ch>
References: <20021017163909.GO344@pc.ilinx> <Pine.LNX.4.33.0210181255170.10340-100000@blackhole.kfki.hu> <20021018144818.GJ2408@naboo.club.berlin.ccc.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
   netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,

>>As it was reported several times on the mailing list, the tcp window
>>tracking patch could cause long SMTP delays in some cases.
>>
>>After dumping a lot of traffic and replaying the streams it turned
>>out that the book-keeping inside the patch could go out of sync when SACK
>>was used. In another words, SACK was not supported by the patch and it
>>could cause legitimate packets to be blocked.

First I wasn't able to reproduce it on a normal box with low traffic but then I 
asked our management if I could test it out on one of our main packetfilters and 
after 3 minutes I saw those strange DROPs and retransmits with interesting TCP 
flag combinations indicating the SACK. While this firewall has a steady 30Mbit/s 
  sustained filtering rate 7/24 with 8 interfaces and around 1200 rules, I 
expected some rules not to work because not only did I use the tcp window 
tracking patch but the packetfilter was still running ipchains with a 2.2.x kernel.

To get to the point: All rules were transitioned (I added the MetaFW layer for 
iptables to our fw suite) and worked very well but the SMTP ones somehow 
generated too many DROPs. I accredit this to the missing SACK support in the tcp 
window tracking patch. I wasn't able to tcpdump nor trace packets back in 
another way because of strict security constraints (don't ask).

>>It'd be very helpful if sites which experienced the long SMTP delays could
>>give a try to the new version of the patch and then send a report: 'yeah,
>>it's seems to be OK' or 'nope, still bad'. :-)
>  
> well, I'd rather not test it on kashyyyk.netfilter.org for some time...

Actually you should, because the problem will be spotted very soon and you can 
then quickly failback to the old kernel without pissing off too many people.

> so I really have to rely on others for testing. Please tell me about
> your erxperience with this new patch.

I will now (after I have more or less proven that without this SACK patch we're 
running into problems too) patch my kernel and try it again. Unfortunately I 
have only a very limited test period because if I screw up 30 fulltime engineers 
won't be able to work properly. My initial test which only lasted for 20 minutes 
cost us around $4000. I will report back as soon as I have done testing with 
this new patch.

Regards,
Roberto Nibali, ratz
-- 
echo '[q]sa[ln0=aln256%Pln256/snlbx]sb3135071790101768542287578439snlbxq' | dc
