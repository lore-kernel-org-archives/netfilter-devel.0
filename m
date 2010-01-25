From: Husnu Demir <hdemir@metu.edu.tr>
Subject: Re: ipset problem.
Date: Mon, 25 Jan 2010 13:57:05 +0200
Message-ID: <4B5D8711.7000802@metu.edu.tr>
References: <4B5991E2.4090700@metu.edu.tr> <alpine.DEB.2.00.1001221419550.13886@blackhole.kfki.hu> <alpine.DEB.2.00.1001232157230.18023@blackhole.kfki.hu> <alpine.DEB.2.00.1001232243150.18342@blackhole.kfki.hu> <alpine.DEB.2.00.1001242243560.20757@blackhole.kfki.hu> <4B5D4582.2030603@metu.edu.tr> <alpine.DEB.2.00.1001251121370.21525@blackhole.kfki.hu> <4B5D81AF.1090808@metu.edu.tr> <alpine.DEB.2.00.1001251246070.21944@blackhole.kfki.hu>
Reply-To: hdemir@metu.edu.tr
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040403040308000104080209"
Cc: "netfilter-devel@vger.kernel.org >> Netfilter Developer Mailing List"
	<netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from likya.general.services.metu.edu.tr ([144.122.144.158]:39102
	"EHLO mail.metu.edu.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560Ab0AYL5u (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Jan 2010 06:57:50 -0500
In-Reply-To: <alpine.DEB.2.00.1001251246070.21944@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040403040308000104080209
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Good point, I did not understand  what I read. Perhaps I am following the IPSET so
long time that I think that I have to compile all kernel. As I read "need the
source tree of ..", I should reload the kernel.



0. You need the source tree of your kernel (version >= 2.6.16 or 2.4.36.x)
   and it have to be configured, modules compiled.


Thanks.

hdemir.



Jozsef Kadlecsik wrote:
> On Mon, 25 Jan 2010, Husnu Demir wrote:
> 
>>> On Mon, 25 Jan 2010, Husnu Demir wrote:
>>>
>>>> I do download xtables-addons-1.22.tar.bz2 and installed it. It has the 
>>>> same problem. 
>>> xtables-addons-1.22 was released two days ago, before ipset-4.2.
>>>
>>>> I could not try ipset-4.2.tar.bz2.
>>> Why can't you install ipset itself? What's the problem?
>> As far as I remember I should pacth the kernel and reload the server 
>> which I did not want. But for the xtables no need to reload the kernel.
> 
> You have to patch the kernel only if you run 2.4.x, as it is written in 
> the README of the ipset source tree...
> 
> Best regards,
> Jozsef
> -
> E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
> PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
> Address : KFKI Research Institute for Particle and Nuclear Physics
>           H-1525 Budapest 114, POB. 49, Hungary


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAktdhxEACgkQHgR50XBBy+mCggCfe47Js52jNJLxxx7S6hblOdqc
Kf8AoM4y/GlopHCFtmOtfPDVEdXWoag4
=fui9
-----END PGP SIGNATURE-----

--------------040403040308000104080209
Content-Type: text/x-vcard; charset=utf-8;
 name="hdemir.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="hdemir.vcf"

begin:vcard
fn:Husnu Demir
n:Demir;Husnu
email;internet:hdemir@metu.edu.tr
tel;work:+903122103330
tel;fax:+903122103303
x-mozilla-html:FALSE
version:2.1
end:vcard


--------------040403040308000104080209--
