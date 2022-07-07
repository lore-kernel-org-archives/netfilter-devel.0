Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A92BC43334
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Jul 2022 16:11:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235823AbiGGQLW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 7 Jul 2022 12:11:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235873AbiGGQLC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Jul 2022 12:11:02 -0400
Received: from wood.hillside.co.uk (wood.hillside.co.uk [IPv6:2a00:1098:82:11::1:1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56ACF599F7
        for <netfilter-devel@vger.kernel.org>; Thu,  7 Jul 2022 09:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=hillside.co.uk; s=wood; h=To:Message-Id:Subject:Date:Mime-Version:
        Content-Type:From:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=913nZaq2hmZHeuoY08xie84mXLa0JyEF+kNaKWJhzxE=; b=eILdhOSQUp8X5/A4LVqthF984D
        YHu8HB61cnrfUNZoCJp5Nn401TVksnmrqSgZLoW0DqqJFlBHjLWMcp+Xxd6dfJnSjtFVeDAH8oEuU
        zyQZ8AvgKORm9XAlvRtoXddsPCXWqlReEtBP8W47QL+3O7xGWCo6IFHdvLzF3FJJK+D8ch8Evy5m/
        hHH9oj425oM0j0dC+zbS8Q5S05x+4jU/F6Nx6hT4GcDmCQKbuy3kEOUsSSKsKpUJ1lrAHYJWHlWsk
        ZqnPVo8ithGCwK58/2AmCgp61DytPFIl+lYUj+s1znGdg48gWa1RyS3NJzcxSVibb/WiRuQYnW16G
        /qImt5aQ==;
Received: from craggy.hillside.co.uk ([81.138.86.234] helo=smtpclient.apple)
        by wood.hillside.co.uk with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pc@hillside.co.uk>)
        id 1o9U4O-008Pk2-D9; Thu, 07 Jul 2022 17:09:35 +0100
From:   Peter Collinson <pc@hillside.co.uk>
Content-Type: multipart/mixed;
        boundary="Apple-Mail=_8F3CDE83-46C2-4E7C-B26F-40C7583C3D10"
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Date:   Thu, 7 Jul 2022 17:09:34 +0100
Subject: [PATCH] Extends py/nftables.py
Message-Id: <24382147-4BE6-48D1-845C-C8DB85253CE4@hillside.co.uk>
To:     netfilter-devel@vger.kernel.org
X-Mailer: Apple Mail (2.3696.100.31)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--Apple-Mail=_8F3CDE83-46C2-4E7C-B26F-40C7583C3D10
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

Pablo Neira Ayuso has asked me to send this patch to this list. It =
closes=20
https://bugzilla.netfilter.org/show_bug.cgi?id=3D1591.

I was not sure if the output from git format-patch should be emailed =
directly, so apologies if an attachment is not what is expected.


--Apple-Mail=_8F3CDE83-46C2-4E7C-B26F-40C7583C3D10
Content-Disposition: attachment;
	filename=0001-Extends-py-nftables.py.patch
Content-Type: application/octet-stream;
	x-unix-mode=0644;
	name="0001-Extends-py-nftables.py.patch"
Content-Transfer-Encoding: quoted-printable

=46rom=208aa11419725b553cc5fdae0a9829c4b65d2cc246=20Mon=20Sep=2017=20=
00:00:00=202001=0AFrom:=20Peter=20Collinson=20=
<11645080+pcollinson@users.noreply.github.com>=0ADate:=20Thu,=207=20Jul=20=
2022=2014:56:33=20+0100=0ASubject:=20[PATCH]=20Extends=20py/nftables.py=20=
Allows=20py/nftables.py=20to=20support=20full=0A=20mapping=20to=20the=20=
libnftables=20API.=20The=20changes=20allow=20python=20code=20to=20talk=20=
in=20text=0A=20to=20the=20kernel=20rather=20than=20just=20using=20json.=20=
The=20Python=20API=20can=20now=20also=20use=0A=20dryruns=20to=20test=20=
changes.=0A=0AFunctions=20added=20are:=0A=0Aadd_include_path(filename)=0A=
clear_include_paths()=0Acmd_from_file(filename)=0Aget_dry_run()=0A=
set_dry_run(onoff)=0A=0ACloses:=20=
https://bugzilla.netfilter.org/show_bug.cgi?id=3D1591=0ASigned-off-by:=20=
Peter=20Collinson=20<pc@hillside.co.uk>=0A---=0A=20py/nftables.py=20|=20=
92=20+++++++++++++++++++++++++++++++++++++++++++++++++-=0A=201=20file=20=
changed,=2091=20insertions(+),=201=20deletion(-)=0A=0Adiff=20--git=20=
a/py/nftables.py=20b/py/nftables.py=0Aindex=202a0a1e89..bb9d49d4=20=
100644=0A---=20a/py/nftables.py=0A+++=20b/py/nftables.py=0A@@=20-13,13=20=
+13,21=20@@=0A=20#=20You=20should=20have=20received=20a=20copy=20of=20=
the=20GNU=20General=20Public=20License=0A=20#=20along=20with=20this=20=
program;=20if=20not,=20write=20to=20the=20Free=20Software=0A=20#=20=
Foundation,=20Inc.,=2059=20Temple=20Place=20-=20Suite=20330,=20Boston,=20=
MA=2002111-1307,=20USA.=0A+#=0A+#=20Extended=20to=20add=0A+#=20=
add_include_path(self,=20filename)=0A+#=20clear_include_paths(self)=0A+#=20=
cmd_from_file(self,=20filename)=0A+#=20get_dry_run(self)=0A+#=20=
set_dry_run(self,=20onoff)=0A+#=20Peter=20Collinson=20March=202022=0A=20=0A=
=20import=20json=0A=20from=20ctypes=20import=20*=0A=20import=20sys=0A=20=
import=20os=0A=20=0A-NFTABLES_VERSION=20=3D=20"0.1"=0A+NFTABLES_VERSION=20=
=3D=20"0.2"=0A=20=0A=20class=20SchemaValidator:=0A=20=20=20=20=20=
"""Libnftables=20JSON=20validator=20using=20jsonschema"""=0A@@=20-116,6=20=
+124,24=20@@=20class=20Nftables:=0A=20=20=20=20=20=20=20=20=20=
self.nft_run_cmd_from_buffer.restype=20=3D=20c_int=0A=20=20=20=20=20=20=20=
=20=20self.nft_run_cmd_from_buffer.argtypes=20=3D=20[c_void_p,=20=
c_char_p]=0A=20=0A+=20=20=20=20=20=20=20=20=
self.nft_run_cmd_from_filename=20=3D=20lib.nft_run_cmd_from_filename=0A+=20=
=20=20=20=20=20=20=20self.nft_run_cmd_from_filename.restype=20=3D=20=
c_int=0A+=20=20=20=20=20=20=20=20self.nft_run_cmd_from_filename.argtypes=20=
=3D=20[c_void_p,=20c_char_p]=0A+=0A+=20=20=20=20=20=20=20=20=
self.nft_ctx_add_include_path=20=3D=20lib.nft_ctx_add_include_path=0A+=20=
=20=20=20=20=20=20=20self.nft_ctx_add_include_path.restype=20=3D=20c_int=0A=
+=20=20=20=20=20=20=20=20self.nft_ctx_add_include_path.argtypes=20=3D=20=
[c_void_p,=20c_char_p]=0A+=0A+=20=20=20=20=20=20=20=20=
self.nft_ctx_clear_include_paths=20=3D=20lib.nft_ctx_clear_include_paths=0A=
+=20=20=20=20=20=20=20=20self.nft_ctx_clear_include_paths.argtypes=20=3D=20=
[c_void_p]=0A+=0A+=20=20=20=20=20=20=20=20self.nft_ctx_get_dry_run=20=3D=20=
lib.nft_ctx_get_dry_run=0A+=20=20=20=20=20=20=20=20=
self.nft_ctx_get_dry_run.restype=20=3D=20c_bool=0A+=20=20=20=20=20=20=20=20=
self.nft_ctx_get_dry_run.argtypes=20=3D=20[c_void_p]=0A+=0A+=20=20=20=20=20=
=20=20=20self.nft_ctx_set_dry_run=20=3D=20lib.nft_ctx_set_dry_run=0A+=20=20=
=20=20=20=20=20=20self.nft_ctx_set_dry_run.argtypes=20=3D=20[c_void_p,=20=
c_bool]=0A+=0A=20=20=20=20=20=20=20=20=20self.nft_ctx_free=20=3D=20=
lib.nft_ctx_free=0A=20=20=20=20=20=20=20=20=20lib.nft_ctx_free.argtypes=20=
=3D=20[c_void_p]=0A=20=0A@@=20-446,3=20+472,67=20@@=20class=20Nftables:=0A=
=20=0A=20=20=20=20=20=20=20=20=20self.validator.validate(json_root)=0A=20=
=20=20=20=20=20=20=20=20return=20True=0A+=0A+=20=20=20=20def=20=
cmd_from_file(self,=20filename):=0A+=20=20=20=20=20=20=20=20"""Run=20a=20=
nftables=20command=20set=20from=20a=20file=0A+=0A+=20=20=20=20=20=20=20=20=
filename=20can=20be=20a=20str=20or=20a=20Path=0A+=0A+=20=20=20=20=20=20=20=
=20Returns=20a=20tuple=20(rc,=20output,=20error):=0A+=20=20=20=20=20=20=20=
=20rc=20=20=20=20=20--=20return=20code=20as=20returned=20by=20=
nft_run_cmd_from_buffer()=20function=0A+=20=20=20=20=20=20=20=20output=20=
--=20a=20string=20containing=20output=20written=20to=20stdout=0A+=20=20=20=
=20=20=20=20=20error=20=20--=20a=20string=20containing=20output=20=
written=20to=20stderr=0A+=20=20=20=20=20=20=20=20"""=0A+=0A+=20=20=20=20=20=
=20=20=20filename_is_unicode=20=3D=20False=0A+=20=20=20=20=20=20=20=20if=20=
not=20isinstance(filename,=20bytes):=0A+=20=20=20=20=20=20=20=20=20=20=20=
=20filename_is_unicode=20=3D=20True=0A+=20=20=20=20=20=20=20=20=20=20=20=20=
#=20allow=20filename=20to=20be=20a=20Path=0A+=20=20=20=20=20=20=20=20=20=20=
=20=20filename=20=3D=20str(filename)=0A+=20=20=20=20=20=20=20=20=20=20=20=
=20filename=3D=20filename.encode("utf-8")=0A+=20=20=20=20=20=20=20=20rc=20=
=3D=20self.nft_run_cmd_from_filename(self.__ctx,=20filename)=0A+=20=20=20=
=20=20=20=20=20output=20=3D=20self.nft_ctx_get_output_buffer(self.__ctx)=0A=
+=20=20=20=20=20=20=20=20error=20=3D=20=
self.nft_ctx_get_error_buffer(self.__ctx)=0A+=20=20=20=20=20=20=20=20if=20=
filename_is_unicode:=0A+=20=20=20=20=20=20=20=20=20=20=20=20output=20=3D=20=
output.decode("utf-8")=0A+=20=20=20=20=20=20=20=20=20=20=20=20error=20=3D=20=
error.decode("utf-8")=0A+=20=20=20=20=20=20=20=20return=20(rc,=20output,=20=
error)=0A+=0A+=20=20=20=20def=20add_include_path(self,=20filename):=0A+=20=
=20=20=20=20=20=20=20"""Add=20a=20path=20to=20the=20include=20file=20=
list=0A+=20=20=20=20=20=20=20=20The=20default=20list=20includes=20/etc=0A=
+=0A+=20=20=20=20=20=20=20=20Returns=20True=20on=20success=0A+=20=20=20=20=
=20=20=20=20False=20if=20memory=20allocation=20fails=0A+=20=20=20=20=20=20=
=20=20"""=0A+=0A+=20=20=20=20=20=20=20=20if=20not=20isinstance(filename,=20=
bytes):=0A+=20=20=20=20=20=20=20=20=20=20=20=20#=20allow=20filename=20to=20=
be=20a=20Path=0A+=20=20=20=20=20=20=20=20=20=20=20=20filename=20=3D=20=
str(filename)=0A+=20=20=20=20=20=20=20=20=20=20=20=20filename=3D=20=
filename.encode("utf-8")=0A+=20=20=20=20=20=20=20=20rc=20=3D=20=
self.nft_ctx_add_include_path(self.__ctx,=20filename)=0A+=20=20=20=20=20=20=
=20=20return=20rc=20=3D=3D=200=0A+=0A+=20=20=20=20def=20=
clear_include_paths(self):=0A+=20=20=20=20=20=20=20=20"""Clear=20include=20=
path=20list=0A+=0A+=20=20=20=20=20=20=20=20Will=20also=20remove=20/etc=0A=
+=20=20=20=20=20=20=20=20"""=0A+=0A+=20=20=20=20=20=20=20=20=
self.nft_ctx_clear_include_paths(self.__ctx)=0A+=0A+=20=20=20=20def=20=
get_dry_run(self):=0A+=20=20=20=20=20=20=20=20"""Get=20dry=20run=20state=0A=
+=0A+=20=20=20=20=20=20=20=20Returns=20True=20if=20set,=20False=20=
otherwise=0A+=20=20=20=20=20=20=20=20"""=0A+=0A+=20=20=20=20=20=20=20=20=
return=20self.nft_ctx_get_dry_run(self.__ctx)=0A+=0A+=20=20=20=20def=20=
set_dry_run(self,=20onoff):=0A+=20=20=20=20=20=20=20=20"""=20Set=20dry=20=
run=20state=0A+=0A+=20=20=20=20=20=20=20=20Called=20with=20True/False=0A=
+=20=20=20=20=20=20=20=20"""=0A+=0A+=20=20=20=20=20=20=20=20=
self.nft_ctx_set_dry_run(self.__ctx,=20onoff)=0A--=20=0A2.30.2=0A=0A=

--Apple-Mail=_8F3CDE83-46C2-4E7C-B26F-40C7583C3D10
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii






Regards
--------------------------------------------------
Peter Collinson


--Apple-Mail=_8F3CDE83-46C2-4E7C-B26F-40C7583C3D10--
