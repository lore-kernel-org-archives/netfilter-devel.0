From: Antti Siiskonen <antti.siiskonen@tut.fi>
Subject: slog target status
Date: 31 Dec 2002 11:05:53 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <m3vg1asglq.fsf@beagle.ton.tut.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

Hello.

There was a message on this list dated

> Date: Tue, 01 Oct 2002 10:53:51 +0200

stating that

>> Would it be possible, in the near future, to use a "ctnetlink" interface
>> to get at the final counters when a conntrack is destroyed? :-)

> Roman has done something like that already for our company, the
> patch (not the final version, but enough to have a glance at it) can
> be fetched at:
> http://www.drugphish.ch/patches/roman/slog-kernel-2.4.18.diff

The patch adds a slog target to the kernel which provides exactly the
functionality requested in the quoted mail. All connections matching
the rule with slog target are logged with connection specific byte and
packet counters when the connection is deleted from the connection
tracking mechanism.

I'm very interested in this patch. I'm curious if the patch has been
updated in any way and also if the user space tools have been patched
to include this target. All information on the subject is very
welcome, I'd love to play around with this. Also if there are other
patches with the same objectives, please let me know.


-- 
//Antti
