From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Call for testing: patch-o-matic-ng
Date: Mon, 5 Jan 2004 16:28:45 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0401051626380.5451-100000@filer.marasystems.com>
References: <Pine.LNX.4.33.0401051336400.15139-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Herve Eychenne <rv@wallfire.org>, Harald Welte <laforge@netfilter.org>,
   Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.33.0401051336400.15139-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 5 Jan 2004, Jozsef Kadlecsik wrote:

> No, that's not so simple. I had just convinced Harald (:-) that we should
> keep the different versions of the same patch in one directory, like:
> 
> foo/
> foo/info			# Common auxiliary files
> foo/help
> foo/linux-2.4.patch		# 2.4 speficic patch and whole files
> foo/linux-2.4/...
> foo/linux-2.6.patch		# 2.6 specific patch and whole files
> foo/linux-2.6/...

Looks excellent for the purpose to me.

And I also agree that these versions is not the same as package versions.
The version of the patch in all directories should be the same, what
differs is what version of Linux the patch applies to.

Regards
Henrik
