From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: connlimit error?
Date: Tue, 5 Apr 2005 16:13:41 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0504051612120.19152@filer.marasystems.com>
References: <1112710072.30219.3.camel@sas>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=X-UNKNOWN; format=flowed
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org, kraxel@bytesex.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Wojciech 'Sas' =?iso-8859-2?Q?Ci=EAciwa?=" <cieciwa@dzp.ntt.com.pl>
In-Reply-To: <1112710072.30219.3.camel@sas>
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

On Tue, 5 Apr 2005, Wojciech 'Sas' [iso-8859-2] Ci=EAciwa wrote:

> In connlimit module for 2.6.11 in line 74 is:
> [..]
> [74]                    found !=3D NULL && ct =3D tuplehash_to_ctrack(f=
ound)
> &&

If I am not mistaken that =3D should be a =3D=3D

Regards
Henrik
