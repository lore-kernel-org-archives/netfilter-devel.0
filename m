From: "David Vogt" <beunlovable@gmail.com>
Subject: Re: development with queues
Date: Thu, 20 Apr 2006 11:30:51 +0200
Message-ID: <859616420604200230v3231f1dfjb5e2269232fbb1db@mail.gmail.com>
References: <f015bcab0604180253m76a8d960q5c7b6d821401927e@mail.gmail.com>
	<859616420604180331g5644e343x8dc47d85278a4f62@mail.gmail.com>
	<f015bcab0604200225y2312a8a3wf8bdecf65472d145@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "miguel Angel Vazquez" <mikinho21@gmail.com>
In-Reply-To: <f015bcab0604200225y2312a8a3wf8bdecf65472d145@mail.gmail.com>
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

2006/4/20, miguel Angel Vazquez <mikinho21@gmail.com>:
> However I would like to use it in a Linksys router working under
> openwrt, and I think it uses the 2.4.xx kernel version.So there=B4s a
> lot of things to do yet :p

You should keep in mind that libnetfilter_queue requires kernel >=3D
2.6.14. For 2.4.x kernels you have to use (deprecated) libipq instead,
for which a good manpage exists.

David
