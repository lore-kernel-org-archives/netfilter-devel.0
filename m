From: Roberto Nibali <ratz@drugphish.ch>
Subject: Re: slog target status
Date: Wed, 08 Jan 2003 00:13:56 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E1B5F34.1080801@drugphish.ch>
References: <m3vg1asglq.fsf@beagle.ton.tut.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Antti Siiskonen <antti.siiskonen@tut.fi>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello Antti,

Sorry for the late reply but I took a hiatus after having spent several 
weeks in the hospital.

>>http://www.drugphish.ch/patches/roman/slog-kernel-2.4.18.diff
> 
> The patch adds a slog target to the kernel which provides exactly the
> functionality requested in the quoted mail. All connections matching
> the rule with slog target are logged with connection specific byte and
> packet counters when the connection is deleted from the connection
> tracking mechanism.
> 
> I'm very interested in this patch. I'm curious if the patch has been
> updated in any way and also if the user space tools have been patched
> to include this target. All information on the subject is very
> welcome, I'd love to play around with this. Also if there are other
> patches with the same objectives, please let me know.

Yes, Roman has sent me an update to that patch which addresses most of 
the issues Harald and me were having at the time of its first drop. He's 
currently doing his diploma thesis and sitting some exams so I will be 
responsible for the patch.

Unfortunately I also have different priorities at the moment so I can't 
do much work on the SLOG target. I've made the latest drop available at:

http://www.drugphish.ch/patches/roman/slog-kernel-devel11.diff
http://www.drugphish.ch/patches/roman/slog-userspace-r3.diff

Unfortunately we haven't forward ported it to newer kernels and the user 
space patch is against 1.2.6a of iptables. Another problem is that I 
lost track of the ctnetlink status so I don't know how quick I can adapt 
the changes into the SLOG patch. Nevertheless it should give you 
something to play with. Your testing and reporting would be very 
valuable to me.

Sorry for the inconvenience and best regards,
Roberto Nibali, ratz
-- 
echo '[q]sa[ln0=aln256%Pln256/snlbx]sb3135071790101768542287578439snlbxq'|dc
