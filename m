From: Max Kellermann <max@duempel.org>
Subject: Re: [PATCH pom-ng 0/5] RFC: ip_nat|conntrack_h323.c on 2.6,
	first preview
Date: Wed, 19 Jan 2005 09:48:56 +0100
Message-ID: <20050119084856.GA15765@roonstrasse.net>
References: <20050119004332.GA12629@roonstrasse.net>
	<Pine.LNX.4.58.0501190900080.10476@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0501190900080.10476@blackhole.kfki.hu>
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

On 2005/01/19 09:30, Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> wrote:
> If you want to write a decent helper, then ethereal has got a H.323
> (ASN) decoder written in C, which could probably be re-used. :-)

Good idea. This parser already helped me during development.

> As for the patch, thus we would overwrite the 2.4 version in pom-ng.
> Please put all the files into a h323-conntrack-nat/linux-2.6
> subdirectory so that the support for 2.4 can be kept. (The
> README.newpatches file in pom-ng describes in detail how to create a
> new patch.)

Ok.

Someone with svn access should copy the directory
h323-conntrack-nat/linux to h323-conntrack-nat/linux-2.6. After that,
I can send patches which modify these copies.

> 
> Please note, pom-ng is unable to take into account the extra version.
> As requirements you should speficy something like
> 
> Requires: linux-2.6 >= 2.6.11

Will this still work with the old 2.4 version then? Is this dependency
ignored when the user wants the old version (and thus only has kernel
2.4)?

Max
