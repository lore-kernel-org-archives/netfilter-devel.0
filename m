From: Jim Carter <jimc@math.ucla.edu>
Subject: Re: Who is using the talk conntrack/nat helper?
Date: Mon, 25 Aug 2003 13:40:32 -0700 (PDT)
Sender: netfilter-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.53.0308251337190.2855@xena.cft.ca.us>
References: <20030824072439.GM6750@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Richard Gooch <rgooch@ras.ucalgary.ca>,
	Netfilter Mailinglist <netfilter@lists.netfilter.org>
Return-path: <netfilter-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030824072439.GM6750@sunbeam.de.gnumonks.org>
Errors-To: netfilter-admin@lists.netfilter.org
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 24 Aug 2003, Harald Welte wrote:
> So the big question is:  Does anybody actually use the talk
> conntrack/nat helper modules?  If yes, are you satisfied with it's
> functionality?

UCLA-Mathnet disabled the talk client and server on internal machines, due
to reported security problems, and excessively risky baroqueness of the
protocol, and we never did the research to find out if they were any better
now then five or six years ago.  We don't care if you toss this module.

James F. Carter          Voice 310 825 2897    FAX 310 206 6673
UCLA-Mathnet;  6115 MSA; 405 Hilgard Ave.; Los Angeles, CA, USA 90095-1555
Email: jimc@math.ucla.edu  http://www.math.ucla.edu/~jimc (q.v. for PGP key)
