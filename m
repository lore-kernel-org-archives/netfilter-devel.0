From: Max Kellermann <max@duempel.org>
Subject: Re: [PATCH pom-ng 0/5] RFC: ip_nat|conntrack_h323.c on 2.6,
	first preview
Date: Wed, 19 Jan 2005 10:06:32 +0100
Message-ID: <20050119090632.GA15919@roonstrasse.net>
References: <20050119004332.GA12629@roonstrasse.net>
	<Pine.LNX.4.58.0501190900080.10476@blackhole.kfki.hu>
	<20050119085615.GD10200@eychenne.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20050119085615.GD10200@eychenne.org>
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

On 2005/01/19 09:56, Herve Eychenne <rv@wallfire.org> wrote:
> Yes... but do we really want a big ASN-1 parser in the kernel?  Is
> there a nice way to have it rely on kernel facilities, while staying
> in userspace though?

The module needs to know one thing: the location of the sender's IP
and port within the data portion of the packet. It currently does that
by looking for the raw IP, and using whatever follows as the port
number.

I believe it's possible to implement a tiny parser without all the
features we don't need. Though I havn't looked at the protocol
in-depth yet.

Max
