From: Fabrice MARIE <fabrice@celestix.com>
Subject: Re: MARK_operations
Date: Fri, 7 Jun 2002 11:59:41 +0800
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200206071159.41320.fabrice@celestix.com>
References: <3CFF8D02.9000003@trash.net>
Reply-To: fabrice@celestix.com
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Patrick McHardy <kaber@trash.net>,
	netfilter-devel@lists.samba.org
In-Reply-To: <3CFF8D02.9000003@trash.net>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hello Patrick,

On Friday 07 June 2002 00:25, Patrick McHardy wrote:
>  Hi.
> Why was the MARK_operations patch moved to broken in latest CVS version ?

MARK_operations was not moved there as far as I can remeber, it was checked'in there
from the begining, because people experienced problem applying the patch. This was
due to a bug I introduced in the ./runme script (fixed for some time now),
and not due to the patch itself. So far, the patch has been working for me.
I simply move it to extra/ before applying patches from p-o-m.
When the coreteam has a bit of time, they'll probably move it there.

Have a nice day,

Fabrice.
--
Fabrice MARIE
Senior R&D Engineer
Celestix Networks
http://www.celestix.com/

"Silly hacker, root is for administrators" 
       -Unknown
