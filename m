From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Call for testing: patch-o-matic-ng
Date: Mon, 5 Jan 2004 13:45:46 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0401051336400.15139-100000@blackhole.kfki.hu>
References: <20040105115533.GK1133@eychenne.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Herve Eychenne <rv@wallfire.org>
In-Reply-To: <20040105115533.GK1133@eychenne.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Herve,

On Mon, 5 Jan 2004, Herve Eychenne wrote:

> I think the convention of Debian Packages files with a line like
> Depends: zope, python2.1-popy (>= 2.0.8), python2.1-popy (<< 2.0.9)
> would just be perfect.

No, that's not so simple. I had just convinced Harald (:-) that we should
keep the different versions of the same patch in one directory, like:

foo/
foo/info			# Common auxiliary files
foo/help
foo/linux-2.4.patch		# 2.4 speficic patch and whole files
foo/linux-2.4/...
foo/linux-2.6.patch		# 2.6 specific patch and whole files
foo/linux-2.6/...

The Requires (in your context: Depends) lines can be added to the info
file, which thus valid for all patch-versions. In Debian, you have one
specific package. Here we have multiple versions of the same patch.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
