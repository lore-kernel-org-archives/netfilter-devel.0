From: Jay Schulist <jschlst@linux-sna.org>
Subject: [PATCH] ctvolume match (replaces previous flow match patch)
Date: Wed, 18 Sep 2002 23:44:51 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44L.0209182333542.18297-102000@hunger.screamingdaemon.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811839-343523500-1032417891=:18297"
Cc: netfilter-devel@lists.netfilter.org,
	Jay Schulist <jschlst@linux-sna.org>, Patrick Schaaf <bof@bof.de>,
	Antony Stone <Antony@Soft-Solutions.co.uk>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
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

---1463811839-343523500-1032417891=:18297
Content-Type: TEXT/PLAIN; charset=US-ASCII

Harald,
Here is a new match which was the flow match patch I sent yesterday, but
this incorporates all the feedback I received.

The main changes are that it has been renamed to ctvolume and now has
better syntax (--gt means greater-than and --eq means equal to) and
corresponding functionality.

Iptables userspace patch is against a clean iptables-1.2.7a
Kernel patch is against a clean linux-2.4.19

# cat /proc/net/ip_conntrack
tcp      6 432000 ESTABLISHED src=192.168.1.3 dst=192.168.1.100 sport=22
dport=3368 pkts=39 bytes=4024 src=192.168.1.100 dst=192.168.1.3 sport=3368
dport=22 pkts=47 bytes=3512 use=1

ctvolume v1.2.7a options:
   --lt-packet  num             Match on less than 'num' packet.
   --lt-byte    num             Match on less than 'num' byte.
   --gt-packet num              Match on greater than 'num' packet.
   --gt-byte   num              Match on greater than 'num' byte.
   --eq-packet num              Match on equal to 'num' packet.
   --eq-byte   num              Match on equal to 'num' byte.

Thanks,
jay-s.


---1463811839-343523500-1032417891=:18297
Content-Type: APPLICATION/octet-stream; name="iptables-1.2.7a-ctvolume-match-2002091911.diff.gz"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.44L.0209182344510.18297@hunger.screamingdaemon.com>
Content-Description: 
Content-Disposition: attachment; filename="iptables-1.2.7a-ctvolume-match-2002091911.diff.gz"

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
+g/daayWdh0AAA==
---1463811839-343523500-1032417891=:18297
Content-Type: APPLICATION/octet-stream; name="linux-2.4.19-ctvolume-match-2002091911.diff.gz"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.44L.0209182344511.18297@hunger.screamingdaemon.com>
Content-Description: 
Content-Disposition: attachment; filename="linux-2.4.19-ctvolume-match-2002091911.diff.gz"

H4sICNJxiT0CA2xpbnV4LTIuNC4xOS1jdHZvbHVtZS1tYXRjaC0yMDAyMDkx
OTExLmRpZmYAtVl7c+JGEv8bPkWHTTbi/TDrjWHtMoex1zmMfQbfXVUqpRLS
CE0sJJU0cuJL/N2vZ0YISQgwdpbdFWj6Mf34TU/PrEFNE+p+OAGbOuEf9U6j
22if1HWbaE6TOrodGqQpSE2HMJPajPgq9Z66Teqpuus4zNf0R5WFnk0aVkrJ
4eLFer3+t9hRuHEduCRz6HyCdrd39FOvfQSdVqtTrFar7zSyMLNCmBIP2ifQ
6vTanV63I3Wfn0P9uFU7hio+2x04Py9CodCswMwi4Pkuc3XXbkClyYdDlTqs
fawySXHCZR+HX8AIWL9YLVY/UBMMYlKHGMrwdnJ5faVe36mTS/VmMBt+VYez
f9+OH25GZfjrr9fwqTe3Fw/jUblY5QbdER+EOxAwjdGAUT0QhlWlXcddtGv+
zEjQTw15GAfC+OAH4hjULMILWl0EguZDKlgG9YvGO7DFVJ09uXa4PBRVScE3
4impovAfYsAF0eGojQnvtVr4F38cnxyMpJTWDIZaPQRqjKFWrQXVdg0hiwji
QHAwwYBpna3T+RUJMu2bhDUpRbm6Hw1mo3vAT2sLy3g0nYL8tLewjP71MBgX
OnyWgPmhziDpGiLFdOHPYjXSEjoBXSA0AREE7Nkj/XySBNYWIgcikl5i2EGz
knEaobsTbZiNpshDnJbm0HVMumhQJ53FXZzb8LRLpnDpUxiECwBeJXpHJ73u
8ZZStFNNBjFHqarT+cyrDj4/i6IDWBE8lfmUr24CPwIw3VsGASw1plsQhJ7n
+uxHyKkXs+HdDWLg+xQJYz34B2KDa8bo/wKlNB1fJrP7wfCfJfjuFEpOCX7t
A7OIUxTJzBqDTjlEZxRrtBzbb9Z0htCFLbNusRYkmnbMLlHX5PgC3Q0Ravst
WWHuQGN4JEy6GcDRf+9G99c3o8lsMC4BBu95T/AeHIG5tKWgJPWUcw1/mAzH
o8Fkm32HLp8b7RGrA+4g+yC8Yjxg8axE3rd2Yi0bS+dTotged8SG3YmWjjv/
rf69sg2BZaieinon0tFwd/BH4Y4lQpm3nTJy8cUictGiRHWrxLoNiGTiPcbl
+/IHYJq/wB07d9LZ4P5qNFPvRz+PhrNYg3xF+UMRkdr/ddcnDX1vjnJkDsBJ
jvT7IJOnMI2ezkmvfbxGT/tIwId/tduy4RN9Vf0M+7gG9YDH1MI3zTD8fpq6
6vtWPKsOkXdU37D9iyyIWjmIP6fQ6q/JovkDyJKjtq9aQFd8wnB0ZTVqfETI
urJNVhTRNB51sGmslNE9qEonqWXXePtbKAitNnGgDt1KHk0oKvdlnLtih2t/
WseZOk/ED5KRdn26qJ8Fvo6v/SxHItqSLzn4jUMeG7IKeiEKdkyQ4S4UcqMc
+k4izEKGRWGOFNSETxgreEFPRFk76fKAfW511yeRSBVaOhgOR3czceD4tp7j
WWMoNtaNc4bO6mfCB0sLrF+Gs+vJ5W3n4vpewa0Ze8jyrw153loBEauTUvGC
x3m5foao6R+gYhV1VNHORBcdVziOsW1BNy7ub+/g40fgii1ie8QvYy8rI4e4
WQ/LbyU2yLEQclYtZWESyoCyNYjM6r+vsmIkHUOzXefg+pqUfGuVTer4G2tt
Sm2m4v4Uq+XA/nTEcY3PqA5glHkRqUaViJdRLDzR8piHpolH3SqvM7W4oHxT
xEfGBMIMM2NBCWtkcPqDbRvydC1/lmool6nLkbVRZSjnFwWxDsSSPxxRiVbh
NTBKsh+EnaTgAYfp/boyXd1nBMrGEfpEHqGxCqWFe1H7vHSNEFtY5oLtuo+g
MdDXpwNxIsDq2sBzRIX/w1LmPWOdtbDf1stiMkwj/Kw9w1S3QhvrG3z5LdAt
O2Dngbacaw3XX5zF4jOLBhylC19bgo49/JyATwwU8+k8ZBgb1+cmUZPi7xBP
/T4/CAAasQzANfmLUHQ1eYAr4hBfs+EunNtUhzHViRMQ0HAGPhJYhGNMyF/6
hMDUNdnvmo9v6JahcQ8bm1bhz6Q9v1NmuSEDzXkGFPY1hz1zI+nSs7mNqzGh
CA1cEl+3cECbU5tKVpMyh+DR08TfGp64fNwDQlvz0UzfcwOyju4UreTm7vDO
FAFCJwzCNGrL1DT5cpZ3L/BFXr7IvDass00S1mdckrmkHZd/r+RHx20SvI45
eR90Jq9TMCs6v/EoVgU8FZw+4FunuGYJHlVuOVTQg9rqoiTFgVOoBnnCWEGF
Ovt5MLMZpieXGlARk/OtKqbyWxjXNAOSL2AZfjy+vtdEkGliH0woqVguM3zX
w0q5viRKGbh5m1QRz1OIzVpfE8Uy2WtaqIivNefmDaXQKrfknQqhossb2Xgn
Fw17QhMesBQlm6UyTxN8jPf8lTjvOL7TWTkeWH0WuHuBI5xcc0tnTrmeV/U6
CU9w7WKFUzgVRZ89wnsZ3Gd0Lci/GOxxquiIpIzciXg/pGTODGeQ5CiXhWBB
OLCyv5DxDtZ6xXVLQqvs8FY6+ZvQCPmf1CxbeGDuE+0xh77pO7/xfL3jXzYc
32JAJhob1H3R+JKJxpumeUM4xO3u6+NxevragByWv33hiefdE593oealWJXL
sQdRv8XPZukRfp54SRdv0C2iP0a1G3dDH2sR3xYcbUlqOTnIFj88yuJxOIdz
W3Fef1K35oIxoP8j+xgtbH3UpRY8pooyT0Gsgp+POE4G4+uricJHXFPZVrDL
OQlJBDCmbQlhQq1s0mLl4rWIzfWf+GfyMB7XxBNesLFeMZWw5go+Xnt5ImoR
5+zr9TRq0/l/WqVTpqLhFOfEh8LDnIoEdo9iGoxIal9wXGyMVi0k70KS4E3u
D5JlMygqt0e9ngzVh+lIHd4+TGa5gv1syHhsfLLARg3bCdkqfExHqZwJqsCO
qpI/0Es8zdBNL+Ud5X6tb3PyYvQKJ4XB8lXkQ+EPTojGuPUKt56PyVSq4+vh
aDIdKaWru3EJx/8PE/psX9AeAAA=
---1463811839-343523500-1032417891=:18297--
