Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D663C38A02
	for <netfilter-devel@archiver.kernel.org>; Sun, 30 Oct 2022 20:57:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbiJ3U5G (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 30 Oct 2022 16:57:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiJ3U5E (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 30 Oct 2022 16:57:04 -0400
X-Greylist: delayed 1183 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 30 Oct 2022 13:57:03 PDT
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 598EC9597
        for <netfilter-devel@vger.kernel.org>; Sun, 30 Oct 2022 13:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
        Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=NtBWS840wXsguPcmvWl70EMTylvD42JTE/4vCuNPIpY=; b=PbYYSNsuRgLOAI9L5D9obNobcI
        UCn5kyuQ34tUuTJ9EJoA4JwlD8bXU5BB30fd50WGQImM+P/7TgxlsTKD6+hYhep8OdNt7+vRL9jAS
        6p44fSnxq4ax1/5M/n7k3MsfxhITOUaSBEwHzXkwWYx9KVuAVe/0XlRddtdqNdBrOqIFtoFm3Tp43
        fjUW4WIPmx2yqCdfzY7FEo8TuN50a1GY7iZZwGD9QjPu6/ZAy9Jimjzc99b5oInW4VlSDTLytsaSj
        fHIym1GUugtD92/ypDqjVTDup3oP1/ZQTuMor/jukzSRfr+3IMtih0VFMGx4xQzPYEV3qG3Xu94Co
        7G0WwtOQ==;
Received: from [2001:8b0:fb7d:d6d7:f47b:9ff:fe41:7a71] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1opF3W-004O6w-PC
        for netfilter-devel@vger.kernel.org; Sun, 30 Oct 2022 20:37:18 +0000
Date:   Sun, 30 Oct 2022 20:37:17 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: ulogd2 release?
Message-ID: <Y17gfeqi1HyQ/l6F@azazel.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="M8OHIxtA2gkgHPTD"
Content-Disposition: inline
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:f47b:9ff:fe41:7a71
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--M8OHIxtA2gkgHPTD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

It's been four years since the last ulogd2 release.  Time for 2.0.8?

J.

--M8OHIxtA2gkgHPTD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmNe4HQACgkQKYasCr3x
BA0AnA/+IuneaQvjtXuxdvo6dFb/eTcnGuEv9C46Y4bDE6WGXuG2LUJpQrXW/ySQ
4JDWrqgJWhJKLz+Ar7elYAvwiBR9xwW1J/raB1ZdWgaON0wLXsCsnt8vePKxaHeO
hy9Xe9Lt3iDXzjPGvaoqe+IlF9YuieSXeQmWXPqBIpKBpDU/zOke/pr+FCGONndY
uLkB2AS6GOY4Du27GqrBqrP2IJ1J9d6ZPmfXnbDzygIm4D8p8cwPR6/dK5zHjmGf
2nLt0V6IyxCAXQfO82V2JMmNYbIJEbXrbbhNqMpJ+Yr+1UJzgAd9A6SekM8hMgtl
SM05zKQZD7hD2OLQWKyQmIsX82g3vlTpTSqqOYX2zK0rzY4vooqfSV8W8Xcs8IWT
hWb+SXgJZvY8A+sJswszVA8RNczQ8adXJH7zoLlf1Jbx5uPOQsgDP2tdhUkvdCgY
77vruRBOH3jJ3VdKUiR+qSciRzsl6eE5/wecqfQvyuNMjgGza2h2Y+Drao6P8ZWR
o1+fTMpPjMXFn7/3Ku9D3YyfzCsKT9MybWZkjl8eYuRRbdTUQvi51sLlI/TTjnfl
S1sGOG5CQvZgbN54qyYIK/GBfDWI0L3Rsgt0dOnZk7xS5YROgy0gnsBmFSmRCEDq
6CAE/NOQekXtbap4KpEWj/lLO5/2ssIO+F+AEDmwtkF5nNIbQgg=
=jfii
-----END PGP SIGNATURE-----

--M8OHIxtA2gkgHPTD--
