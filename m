From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH] User defined udp and tcp conntrack state timeouts
Date: 19 Sep 2002 22:35:47 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1032467747.5564.42.camel@tux>
References: <20020919084658.J3810@sunbeam.de.gnumonks.org>
	<Pine.LNX.4.44L.0209182252170.18297-101000@hunger.screamingdaemon.com>
	<20020919204619.W3810@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Jay Schulist <jschulist@bivio.net>,
	Harald Welte <laforge@gnumonks.org>, Patrick Schaaf <bof@bof.de>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jay Schulist <jschlst@linux-sna.org>
In-Reply-To: <20020919204619.W3810@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 2002-09-19 at 20:46, Harald Welte wrote:

> > Here is a new patch which does the conversion from jiffies to seconds for
> > the user.
> 
> Again, another issue (sorry)...
> 
> There are _lots_ of changes between conntrack in 2.4.19 and conntrack in
> current 2.4.20-preX (where X > 2) kernels.  Could you please merge your
> patch with recent kernel?  If this is not possible, I will ask the 
> 2.4.x-patchomatic-maintainers to do this job.
> 
> Thanks a lot.

I've rediffed it against 2.4.20-pre7 and it also applies fine (some
offsets) to 2.4.19 with almost all patches (clashes with
tcp-windowtracking as expected).

I took the liberty to change the name to ip_conntrack-timeouts as it
fits in better with the namingscheme in p-o-m. I hope that's ok.

I've put together a help file for p-o-m from your original announcement.
And I've committed this patch to cvs (my understanding is it has been
approved for inclusion)

http://cvs.netfilter.org/cgi-bin/cvsweb/netfilter/patch-o-matic/extra/ip_conntrack-timeouts.patch?rev=1.1
http://cvs.netfilter.org/cgi-bin/cvsweb/netfilter/patch-o-matic/extra/ip_conntrack-timeouts.patch.help?rev=1.1

If you want anything changed please let me know.

Harald, you'll add the scoreboard entry?

-- 
/Martin

Never argue with an idiot. They drag you down to their level, then beat
you with experience.
