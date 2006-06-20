From: Patrick McHardy <kaber@trash.net>
Subject: Re: checking rule specifications in a match
Date: Tue, 20 Jun 2006 15:23:23 +0200
Message-ID: <4497F6CB.4030600@trash.net>
References: <44966994.6020402@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: =?ISO-8859-15?Q?Bj=F6rn_Lindstr=F6m?= <bjorn.mailinglist@gmail.com>
In-Reply-To: <44966994.6020402@gmail.com>
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

Bj=F6rn Lindstr=F6m wrote:
> Hi.
> I am writing an iptables match to match the IEC-60870-5-104 protocol.
> I only want this match to be used on tcp packets and therefore I want
> iptables to reject rules if does not specify tcp as the protocol (-p
> tcp). I am currently doing this check in the checkentry function in the
> kernel module. This works but the error message only say "iptables:
> Unknown error 4294967295" if -p tcp is left out. Is it possible to do
> this check any other way to get a more comprehensible error message?

This is probably because you're using a broken version of iptables
userspace. Current kernels allow you to enforce a specific protocol
by setting the .proto field in struct xt_match, which will also handle
inversion correctly and logs a message to the ringbuffer on error.
