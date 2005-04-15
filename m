From: Adrian Turcu <adrian.turcu@gmvinteractive.com>
Subject: Re: CONNMARK behaviour
Date: Fri, 15 Apr 2005 09:23:17 +0100
Message-ID: <200504150923.18886.adrian.turcu@gmvinteractive.com>
References: <200504141447.19432.adrian.turcu@gmvinteractive.com>
	<200504150900.07990.adrian.turcu@gmvinteractive.com>
	<Pine.LNX.4.61.0504151002410.19084@filer.marasystems.com>
Reply-To: adrian.turcu@gmvinteractive.com
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.LNX.4.61.0504151002410.19084@filer.marasystems.com>
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

On Fri 15 Apr 2005 09:06, Henrik Nordstrom wrote:
> Yes. Any sequence which sets both the packet mark and the connection mark
> is fine.
>
>    CONNMARK --set-mark
>    CONNMARK --restore-mark
> or
>    CONNMARK --set-mark
>    MARK --set-mark
> or
>    MARK --set-mark
>    CONNMARK --save-mark


I got it now, thanks. ...And I'll put a bookmark on this for the future.

Regards,
Adrian
