From: Eric Leblond <eleblond@inl.fr>
Subject: Re: About the version of libnfnetlink and libnetfilter_queue in
	RHEL 5.2!
Date: Fri, 31 Oct 2008 11:13:02 +0100
Message-ID: <1225447982.15163.19.camel@ice-age>
References: <web-4607695@mail.primecreation.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	michael.tso@primecreation.com, michael.soong@primecreation.com
To: Jacky Luk <jacky.luk@primecreation.com>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <web-4607695@mail.primecreation.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Le vendredi 31 octobre 2008 =E0 14:51 +0800, Jacky Luk a =E9crit :
> Hi,
>=20
> I would like to ask something about the version of=20
> libnfnetlink and libnetfilter_queue. What is the most=20
> stable and suitable version of libnfnetlink and=20
> libnetfilter_queue for developing the application with=20
> netfilter_queue in RHEL 5.2 (Kernel: 2.6.18-92.el5)?

You should use latest releases for the maximum stability. They are
backward compatible with older kernel.

>From a functionnal point of view, you should at least use
libnetfilter_queue-0.0.15 and libnfnetlink-0.0.30. They provide
interface name resolution, that you may want to use in your application=
=2E

BR,
--
Eric Leblond

