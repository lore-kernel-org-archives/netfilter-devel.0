From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH] conntracker/nat helper for Microsoft Media Services
Date: 10 Oct 2002 16:55:12 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1034261712.25146.16.camel@tux>
References: <1032732902.574.99.camel@exile>
	<20020924133925.M3810@sunbeam.de.gnumonks.org>
	<1032870935.6100.10.camel@xbox>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Filip Sneppe (Cronos)" <filip.sneppe@cronos.be>
In-Reply-To: <1032870935.6100.10.camel@xbox>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

I just committed a small change to cvs.
http://cvs.netfilter.org/cgi-bin/cvsweb/netfilter/patch-o-matic/extra/mms-conntrack-nat.patch?r1=1.2&r2=1.3&f=u

Without this change nfnetlink-stuff won't compile in userspace, all
other helpers have been changed over to this format.

-- 
/Martin

Never argue with an idiot. They drag you down to their level, then beat
you with experience.
