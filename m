From: Patrick McHardy <kaber@trash.net>
Subject: Re: New H.323 conntrack & NAT helper module
Date: Sat, 25 Feb 2006 10:01:17 +0100
Message-ID: <44001CDD.3030305@trash.net>
References: <925A849792280C4E80C5461017A4B8A2032119@mail733.InfraSupportEtc.com>
	<BAY109-DAV1E3EEAC01132FB3EE2E2EB3F00@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Greg Scott <GregScott@InfraSupportEtc.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jing Min Zhao <zhaojingmin@hotmail.com>
In-Reply-To: <BAY109-DAV1E3EEAC01132FB3EE2E2EB3F00@phx.gbl>
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

Jing Min Zhao wrote:
> I think maybe Patrick McHardy is inspecting my code, if I'm lucky,
> it may go into the kernel tree, and you won't need a separate
> patch any more. I really hope so.

I'm almost done reviewing it. It really looks great, it is the IMO
cleanest conntrack helper so far, which is really an achievement
for such a complex thing. I've fixed a number of smaller issues
and prepared patches for that, I'll send the first batch in follow-up
mail.

Besides my patches, I have a few small issues with the patch, but if
they are resolved I'd be happy to put this helper into 2.6.17.

The issues so far:

- ASN1 parser: I would prefer the parser to be seperated from the
  H.225/H.245 data.

- ASN1 parser: Right now the H.225/H.245 data includes lots of
  forward declarations, probably because it seem to be in the
  same order as in the ASN.1 file. The forward declarations make
  it a lot harder to verify that their is no recursion, so I would
  prefer to have the data ordered in a way that doesn't need them.

- TPKT handling: I've seen gnomemeeting send nested TPKTs about a year
  ago when I worked on my helper. I can't get it do it anymore, but my
  question is if it nested TPKTs are something that should be supported.

- process_rcf uses the stored sig_port to find the expectation and
  adjust it's timeout. The sig_port is only set with NAT however.
  This seems to be a bug.

- RAS tracking: should be made optional IMO. This is the only part
  where foreign IP addresses not belonging to the connection are
  used for expectations, which is potentially dangerous.

I'll describe the other issues in the mails containing the patches.
