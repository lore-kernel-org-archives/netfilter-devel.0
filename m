From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [netfilter-core] ip_conntrack_ftp & publicfile software
Date: Mon, 2 Feb 2004 15:29:50 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0402021518010.6508-100000@blackhole.kfki.hu>
References: <E1AneWQ-0001DT-00.k1c-mail-ru@f13.mail.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>, <coreteam@netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "=?koi8-r?Q?=22?=M.Alhimenko=?koi8-r?Q?=22=20?=" <k1c@mail.ru>
In-Reply-To: <E1AneWQ-0001DT-00.k1c-mail-ru@f13.mail.ru>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

On Mon, 2 Feb 2004, [koi8-r] "M.Alhimenko[koi8-r] "  wrote:

> I has trouble with publicfile software
> (http://cr.yp.to/publicfile.html) and linux module ip_conntrack_ftp.
> Description and resolve (by patching ftpd) in my page:
>
> http://lithium.opennet.ru/publicfile-patch-en.html

There are a few problems with your patch:

- in the patch you actually kill supporting standard passive FTP
- it's a reverse patch
- I think it's easier to convert publicfile to be conform
  with RFC-959 to the letter, than to patch the kernel. RFC-959 lists
  the suggested reply messages - why should publicfile invent another one?

And please send such messages to netfilter-devel@lists.netfilter.org,
which is the appropriate forum to discuss new features.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
