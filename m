From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: Update: Patch-o-matic cleanup
Date: Sun, 30 Apr 2006 12:44:55 +0200
Message-ID: <20060430124455.kkdqfyfyvej4c4o4@intranator.m.i2n>
References: <443165AA.4030509@trash.net> <4433CA75.9040607@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <4433CA75.9040607@trash.net>
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi Patrick,

> Patrick McHardy wrote:
> How to set up a repository:
>
> The repository must be accessible in a way supported by curl (HTTP or
> FTP for example). The name of each patchlet is listed in a file named
> "index". Each patchlet must be contained in a .tar.gz file, which
> contains a directory named like the patchlet itself. The directories
> contents are similar to those in patchlets/ today, but the Repository
> specified in the info file must be "external".

I've set up a repository for ACCOUNT here:

http://www.intra2net.com/de/produkte/opensource/ipt_account/

Hope everything is ok.

The tarball is currently named ACCOUNT.tar.gz.
Is there a way to add a version number to it?
Or is it safe to include some kind of "Changelog"
file in the distribution?

btw: "README.new_patches" doesn't know anything
about the "Repository: external" stuff yet.

Cheers,
Thomas
