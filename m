From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: [PATCH] fxp support for ip_conntrack_ftp.c
Date: Tue, 20 Dec 2005 14:23:19 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0512201422420.31684@bizon.gios.gov.pl>
References: <20051220141315.44643c09.gmsoft@tuxicoman.be>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1037929085-1135084999=:31684"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Guy Martin <gmsoft@tuxicoman.be>
In-Reply-To: <20051220141315.44643c09.gmsoft@tuxicoman.be>
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

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-1037929085-1135084999=:31684
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Tue, 20 Dec 2005, Guy Martin wrote:

> Hi netfilter hackers,
>
> This patch enables you to allow so called FXP transfer by allowing=20
> connection from a different source address than the one which initiated=
=20
> the transfer.
>
> To enable, simply modprobe ip_conntrack_ftp fxp=3D1.

How it is different from loose=3D1?

Best regards,

 =09=09=09Krzysztof Ol=EAdzki
---187430788-1037929085-1135084999=:31684--
