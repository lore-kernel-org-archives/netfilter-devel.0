From: Nils Ohlmeier <lists@ohlmeier.org>
Subject: Re: SIP helper review
Date: Mon, 20 Feb 2006 21:45:20 +0100
Message-ID: <200602202145.20377.lists@ohlmeier.org>
References: <200602192312.05240.lists@ohlmeier.org> <43F9FDC3.50102@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Christian Hentschel <chentschel@arnet.com.ar>,
	Harald Welte <laforge@gnumonks.org>, Harry Behrens <harry@behrens.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <43F9FDC3.50102@trash.net>
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

On Monday 20 February 2006 18:34, Patrick McHardy wrote:
> Nils Ohlmeier wrote:
> > 1) As far as I got it the skp_epaddr_len function in ip_conntrack_sip.c
> > expects to find a username in the SIP URI in the Contact header. As
> > usernames are generally optional in SIP URIs there are several User
> > Agents (UA), especially the cheaper hardware UA's which support only one
> > SIP account, which do not put a username into their Contact's. Thus I
> > would propose that the searching for the username in the Contact header
> > should be optional as well.
>
> I think this is what made the helper fail with my crappy chinese SIP
> ATA. Without the username, is there still an '@'-character (in which
> case it should work as it is) or does the string start directly with
> the address?

The two valid alternatives are (omitting secure SIP, because it couldn't be 
patched anyway):
 - sip:user@host
 - sip:host
The first alternative is used by the majority of the devices. But if you have 
a simple hardware with only one account there is no plus in adding a username 
to the URI. Their are some devices which use the later. So some more devices 
could be supported by netfilter if the username would not be mandatory.

> > 2) As far as I got it the epaddr_len function looks for 'UDP' in Via
> > headers. Is it by intention that the IP address replacement would only
> > work for the UDP transport but not for TCP? Allthough TCP is not very
> > widely used yet I think it should be easy to do the replacement for TCP
> > as well, or?
>
> It should be easy to change. Is TCP used for SIP itself? In that case
> it would also have to register for TCP in addition to UDP.

Yes. In fact TCP should have precedence if it is supported by both sides. But 
currently most of the providers do not offer/support it (on their server 
side). So currently the add-on value by supporting TCP as well would be 
small. But I think it will become more important in the future.
Allthough I understand that the payload fragmentation with TCP would be a 
problem for the netfilter module, I would assume that the Via header should 
always appear early in a message. So it might be worth thinking about it for 
the future.

Greetings
  Nils
