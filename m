From: Patrick McHardy <kaber@trash.net>
Subject: Re: conntrack match and locking
Date: Thu, 27 May 2004 03:32:38 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40B54536.4000000@trash.net>
References: <Pine.LNX.4.58.0405241628000.27895@chris.camcom.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Chris Wilson <chris@netservers.co.uk>
In-Reply-To: <Pine.LNX.4.58.0405241628000.27895@chris.camcom.co.uk>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Chris Wilson wrote:
> Hi all,
> 
> The conntrack match from POM-ng doesn't appear to do any locking while 
> accessing conntrack structures. Is that a problem? If so, how can I fix 
> it? I can submit a patch if someone can tell me what lock(s) I need to 
> hold.

Actually it doesn't require locking. Everything it looks at it is either
read-only after the connection has been confirmed, or modified without
locking (status).

Regards
Patrick

> 
> Cheers, Chris.
