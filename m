From: Michael Rash <mbr@cipherdyne.com>
Subject: Re: [PATCH] snort hex strings and libipt_string.c
Date: Tue, 18 Feb 2003 17:09:23 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030218170923.A23930@orthanc.gambrl01.md.comcast.net>
References: <200302182230.h1IMUPh07379@singularity.tronunltd.com> <Pine.LNX.4.44.0302181647350.5477-100000@sparrow>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ian Latter <Ian.Latter@mq.edu.au>,
	Michael Rash <mbr@cipherdyne.com>,
	ML-netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: William Stearns <wstearns@pobox.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0302181647350.5477-100000@sparrow>; from wstearns@pobox.com on Tue, Feb 18, 2003 at 04:48:34PM -0500
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Feb 18, 2003, William Stearns wrote:

> On Wed, 19 Feb 2003, Ian Latter wrote:
> 
> > Hi Michael,
> > 
> >   This looks  pretty cool ... do you provide any scripts to load up the snort
> > data into iptables automagically?
> 
> 	http://www.stearns.org/snort2iptables/ did most of the rules 
> before this patch became available.

Yes, and in fact snort2iptables is exactly why I wrote the patch
since it is putting non-printable ascii chars into iptables shell
commands.  I want to be able to take the snort signature database
and translate it directly into iptables rules without having to
do this.

(I'm actually reworking the patch right now since it is not flexible
enough to handle the various ways hex data can be included in snort
signatures.)

--Mike

Michael Rash
http://www.cipherdyne.com
Key fingerprint = 4EE3 816C 413A 41AA 72C8  4463 70C3 783C 1B91 F85E
