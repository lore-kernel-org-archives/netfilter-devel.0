From: "Laurence J. Lane" <ljlane@debian.org>
Subject: Re: hppa and s390 build error, 1.2.9 + 2.4.24 headers
Date: Sun, 29 Feb 2004 19:21:45 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040301002145.GA21280@absolom.libra.net>
References: <20040213174222.GC14190@absolom.libra.net> <20040214205527.GZ7756@sunbeam.de.gnumonks.org> <20040224234109.GE10431@absolom.libra.net> <20040229210839.GP15558@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
Resent-Message-ID: <20040301015443.GA1575@absolom.libra.net>
To: Harald Welte <laforge@netfilter.org>,
	netfilter-devel@lists.debian.org
Content-Disposition: inline
In-Reply-To: <20040229210839.GP15558@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, Feb 29, 2004 at 10:08:39PM +0100, Harald Welte wrote:

> > > Unfortunately I don't have access to any of those machines to
> > > further debug the problem.

> > Debian affords many. Sign up to become a developer:

> Sorry, but I'm definitely not going through the time-consuming
> process of becoming a debian developer, just to hunt down a
> problem in the build process of S/390.

I was mostly joking, but there are many benefits available to
developers and free software projects. It takes talented volunteers
to make it happen. You're still invited to sign up.

> Either there is somebody seriously interested in getting this
> running on S/390 and thus at least provide me access to such a
> machine, or the issue is not that important after all.

I copied the atomic_t typedef from asm/atomic.h to make it build. 

I suspect a gcc bug.
