From: Nils Ohlmeier <lists@ohlmeier.de>
Subject: Re: conntrack manipulation
Date: Tue, 13 May 2003 15:52:44 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200305131552.44424.lists@ohlmeier.de>
References: <200305122335.h4CNZpL24181@singularity.tronunltd.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Ian Latter" <Ian.Latter@mq.edu.au>
In-Reply-To: <200305122335.h4CNZpL24181@singularity.tronunltd.com>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Ian,

On Tuesday 13 May 2003 01:35, Ian Latter wrote:
>   How, then, does  this differ from either the FTP conntrack+nat
> module?  Surely you just want to right a small connection tracker
> that understands your phone protocol and relays connections
> appropriately?

SIP differ in a lot points from FTP:
- it uses normaly UDP not TCP (although TCP is possible according to the 
newset RFC3261)
- it needs more then one related connection (ok thats not a problem any more)
- its a ASCII based protocol related with http
- it can contain hostnames instead of IP <- and thats the reason why it exist 
no conntrack helper and i do/will not write such a module

Regards
  Nils Ohlmeier
