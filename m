From: Jay Schulist <jschlst@linux-sna.org>
Subject: Re: [PATCH] User defined udp and tcp conntrack state timeouts
Date: Thu, 19 Sep 2002 01:43:48 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44L.0209190130540.18297-101000@hunger.screamingdaemon.com>
References: <20020919204619.W3810@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811839-1204918394-1032425028=:18297"
Cc: Jay Schulist <jschulist@bivio.net>, Patrick Schaaf <bof@bof.de>,
	<netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <20020919204619.W3810@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
  Send mail to mime@docserver.cac.washington.edu for more info.

---1463811839-1204918394-1032425028=:18297
Content-Type: TEXT/PLAIN; charset=US-ASCII

On Thu, 19 Sep 2002, Harald Welte wrote:

> There are _lots_ of changes between conntrack in 2.4.19 and conntrack in
> current 2.4.20-preX (where X > 2) kernels.  Could you please merge your
> patch with recent kernel?  If this is not possible, I will ask the
> 2.4.x-patchomatic-maintainers to do this job.
>

No problem - I didn't even think to do it against 2.4.20-*. Here it is
against 2.4.20-pre7, let me know if there is anything else.

Thanks,
jay-s.

---1463811839-1204918394-1032425028=:18297
Content-Type: APPLICATION/octet-stream; name="linux-2.4.20-pre7-ct-timeouts-2002091913.diff.gz"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.44L.0209190143480.18297@hunger.screamingdaemon.com>
Content-Description: 
Content-Disposition: attachment; filename="linux-2.4.20-pre7-ct-timeouts-2002091913.diff.gz"

H4sICPCNiT0CA2xpbnV4LTIuNC4yMC1wcmU3LWN0LXRpbWVvdXRzLTIwMDIw
OTE5MTMuZGlmZgC1WftT4kgQ/jn8FV1ulaeQQBIevm63RMye1GKwCN7u3tZW
KoZBcoaESwbXvS3/9+uZxJBAeCgcUoLpx/T0dH/zzThwhkOQgqkOruNNnyS1
XCursjQJyJFku8TyKo5nu9MBqXB5xSN06LiUBKYzeaxVnIlp+55HA8t+KI8W
fbzGuiBJ0i6iEPqjKRhkAsoJyLXTKr5PQJVltVAqlbYLcc61iu/jyPX5OUhq
/VisQ4l9nMD5eQGeC1AA8oTOPJh6oXPvkQE4HoW0V3NErTuXmKHzLzkrlAql
ShGYkNjU8T3gOo53D9QZE/CnFB6twGEWYRmKlUIp9s/chj9Dm7pmxju1JyYz
RcvwmyJ/P1trMR2kLFQ0gHfEGzhDwMBM85PW07WOabKx04L2jdnq6nq/12x9
Mq+YdLC70mIxbVdekYfdlFjkS/iMi3lJbKgqWA6nsoxv/NI42bbMYvfZUpOV
U1WdlZosylBSxAYrs9I7Z+gNyHBuDW4vb8wrFKLE8Ui+cCZmD/rta61724fU
S85qGP2e1rzOKCqAKkvKgI+yWSlgPio8E0lisjmx/YCU7Zy0bma4cuE3c7EI
KzV5Fay8yevcMjcauMQl/K1GgBLSYGpTHCyk5ohYAyhmkcQKR2dMy6KODQ9j
MjZtyx4Rk84p8qcTVJ0tr6G1DIAiXP01e3bd1vmzhszFM8FV97ZnRAKmMxNc
Nr9yC7UW6bAS2xSZ4D38KpTiwqtGnsWXQsTa4q9+K11gelfXxHS9ckSMv9Z5
NDNxvgvN6DcvOm3jSrsUF1yo2SCWuDC+6qah6X0xL4o4d+J6Fz2t9Weui82i
+NjWzc/Ndn8LF6yvsz5SLpSNJtLqdI3skrw6F9xFJoyUi+pGLjpNo2/ily1y
gSXR13RxbiLPZ6sqem7nZAUNayO/1XvaTaetXUL+q1iZ+VCO5bhRsz6ahnHb
W+ohFfoLG4mBJBP9JPCpb/tu9uk98Ujg2ImUgcYLwjiey5qepYOLTXs8GXoH
aBzS1UMU7WkQiBzjlGqtxlBOqTaOxGMOc3znEUG/7XTgmQ/4gi+61s9uMdfN
LwiXxyczCFpQYesa71iYOFU+kVcop/bBSFlZPbipN6812MvMcmw97fGgnSHb
llH/Y/sPbHGj1e/EU66r0ZSPjkSlFkM7TymrKc4Hs4njj75FEAnCr9xQxOUB
irA/H6GIfgAY6fSHB/PCQxHkBi4L8DUQ2era5sDHhX5EwvMsFkp5MaQTLc7l
JA32e2JS0PjaX7c3ZLTjgNfZHGaMorlEU9nPzMX8G5mJQ0IxCSN+sHSS6QKZ
n2S6/zeYZFp900mmbXYySWDlJLOjCu+07ZlahAS4GG+iaynrrThbys+uidty
13PsDddDxfMghzfW4sJetKnsxbmWMtyriMxLyjCvGfGSlhEvKUO8UrxLYj8x
piRHT9dn58g07fpekNgmlbAtoVIUciiWgBuIlOJUi2ppGpVoxzvtonbCmBLV
F2qQr8up0Xq3CQVarzqjOomusjSEiNRsEGuKuiTa1aXaCUtZH27MRrgi1o40
25RCvZtDilNyzVjOeFNqhrGE1UZXG7IqHuGGdVyNt2hB4LC2z8ppJH1gfRGS
f+D9e0gaRfrAO6XMOmVkeYNwZD0QEwWHzFwICTXvHHrQvjHMmL+YF4zz7ac8
sAqehoe8WwSBtSE1AzIMSDg6SNTEbE175Eci+o6mpRWGTCisPZzMewSB3+wI
AaFTJFP6R1zFlnbTP9sZfLIrgLfDJ7feAXxyP/8PfOa5noPPungCpTqWHau3
d/H1Cfwe3Z84Xnn0YfExvzrJeb7quuWFlDJDaYao6RuRg6qM8HyYFc5dhhwg
OedKpdcM/hJwilNTYJv85IGabJuZTlwSM+pH38ET/8Ci1kjkHAHP9ewvl3gi
bynOHXJoN3cCRf5xGOVWFRUFsyuLSjXqZzxKtIfwg/z2iGBACL94RJJgw51P
R/DD+on0gY6cEPAd+mMCD443AH/IUsGpJBuZWOMygIZnDJTF7cNvKUFwhnCw
0NiwD6z9DU1jGH/T+XqI/HZVoy/m/a0NnjmrLbqN2pxlpemGvghjPyBY7A/E
/QnUhzvk5+OJH1DLoyIguIHnU7AYUUYRn/BrAU54BuKGZO30dz3v9IRzMQ25
4fawhvP0BhYSkLfd4qXNtwK2tKNdI9sK33L9tFqfQVu1IbPzH/uItlPty023
18c99/qi28kex0bEnSB0TL2A3DshDsoWalGf4v7rsv8ZPBKTp2I6WaYYlwur
oKx47alqI4vMEWVJCAiigwh4V2pEc89XScYjTxPCZ+ValAxQ+T8s6me71BoA
AA==
---1463811839-1204918394-1032425028=:18297--
