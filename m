From: Felix Kluge <f.kluge@agdsn.de>
Subject: nft bug: Deleting map elements with intervals
Date: Sun, 26 Feb 2017 17:38:55 +0100
Message-ID: <20170226163855.v56ljeaelgqypaeq@wendy>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="h6cgo6lwbw7zxb6c"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from atlantis.wh2.tu-dresden.de ([141.30.228.39]:36588 "EHLO
        atlantis.wh2.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751092AbdBZRQ5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 26 Feb 2017 12:16:57 -0500
Received: from wendy (unknown [141.76.119.134])
        by atlantis.wh2.tu-dresden.de (Postfix) with ESMTPSA id 5BA9983A6D0
        for <netfilter-devel@vger.kernel.org>; Sun, 26 Feb 2017 16:38:56 +0000 (UTC)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--h6cgo6lwbw7zxb6c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

we're currently trying to use a vertict map to jump to other chains. The
key of the map is a subnet.

table ip filter {
  map cgn_map {
    type ipv4_addr : verdict
    flags interval
    elements = {
      100.64.2.0/24 : goto chain-100-64-2-0}
  }
}


Adding new elements to the map works well:

nft add element filter cgn_map { 100.64.3.0/24 : goto ratelimit-100-64-3-0}


However, deleting elements from the map does not work:

nft delete element filter cgn_map 100.64.2.0/24
<cmdline>:1:36-45: Error: syntax error, unexpected string, expecting '{' or '$'


I would appreciate any hints how to solve this issue.

We have build nft from the current master branch, last commit is b2d7b78af50d199201e7e0d6de7c1ba9ba471c12.


Greetings
Felix

--h6cgo6lwbw7zxb6c
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEV/BSPwZd8JiETJdhJ4c2H+BRO8IFAlizBJwACgkQJ4c2H+BR
O8KVDAf+KON8jBRqe2zM8kp2YPjWql2V+Ydoyv/C434bEQG910KTSamxNw/5dsSF
kiqGaS+a1YVXt83gBJjXb43opRCH/zzWh5bXnHsv3v7jI/sL6FSDWJYJH7L+XSr3
w0bAkU4nVWovt8xGVE6nOg5DyQH5m/DOjKeRuULA+5N9dGt6j8y4CMya9qJryrP3
vfvJUzWbglT05pa9TUrPtBwRyFnLMQktJLoQFd71zrxqRuCpLxZ4vy0+46DPCUqn
bK+R59dRPLPdFPN8pOlROPOjuafRP37HbLolJB9w9+cAerT9Rot89toitVZkeSdX
K+8gMUcqh0etkMtDcFLuxINwItKV7g==
=XZwt
-----END PGP SIGNATURE-----

--h6cgo6lwbw7zxb6c--
