From: Jay Schulist <jschlst@linux-sna.org>
Subject: Re: [PATCH] User defined udp and tcp conntrack state timeouts
Date: Wed, 18 Sep 2002 22:54:42 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44L.0209182252170.18297-101000@hunger.screamingdaemon.com>
References: <20020919084658.J3810@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811839-15845461-1032414882=:18297"
Cc: Jay Schulist <jschulist@bivio.net>, Patrick Schaaf <bof@bof.de>,
	<netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <20020919084658.J3810@sunbeam.de.gnumonks.org>
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

---1463811839-15845461-1032414882=:18297
Content-Type: TEXT/PLAIN; charset=US-ASCII

On Thu, 19 Sep 2002, Harald Welte wrote:

> was impossible to have an architecture-independent /etc/sysctl.conf for icmp
> rate limiting - even user mode linux has a differrent HZ...
>
> I'm postponing this patch until the change was made.
>

Here is a new patch which does the conversion from jiffies to seconds for
the user.

Thanks for the feedback,
jay-s.

---1463811839-15845461-1032414882=:18297
Content-Type: APPLICATION/octet-stream; name="linux-2.4.19-ct-timeouts-2002091910.diff.gz"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.44L.0209182254420.18297@hunger.screamingdaemon.com>
Content-Description: 
Content-Disposition: attachment; filename="linux-2.4.19-ct-timeouts-2002091910.diff.gz"

H4sICLNliT0CA2xpbnV4LTIuNC4xOS1jdC10aW1lb3V0cy0yMDAyMDkxOTEw
LmRpZmYArVh7T9tIEP/b+RQjKnGQ2ImdByVwrUiDOaIGB8Xh2t6psoyzIT4c
O2evKb2K736za+Os84YQEDGex87MzuO3O3RHI1DC2ADP9eNHpVqul7Wm4njE
9iuu73jxkFQ4qeITOnI9SkLLnT7UK+7UcgLfp6Ht3JfHOfGXCBYURdlxbeki
dKEV3wFUoaqe1Jon9QY+qNVCqVR6tWHSYByDSaagNUHVUOWJVku0np2Boh03
5AaU2FcTzs4K8FSAApBHVOZD7EfunU+G4PoURK3WmNq3HrEi9z9yWigVSpUi
MCJxqBv4wHlc/w6oOyEQxBQe7NBlElEZipVCKdXP1EY/I4d6Vk47daYWE0XJ
6G9N/X66USIeChJVFIB3xB+6I0DDLOuz3jf0rmWxtUVC59pq9wxj0G+1P1uX
jDp8kzRi5rw6lRLhndMpUSN9wd07Jw7UNNz/E1XFX3w4au6QUqnmtWmlyiom
lXzEUqr0zh35QzKai/fN+bV1iUSkuD5ZTpyR2YtB50rv3QxA+Kh5DnPQ11tX
OUYNkGXFlvNVNm47hqLCg5DFJB8OJwhJ2ckHczuZVZu8nfSSdnG0ol1sqXBu
S49O1KPZljYauJ0l/FtNGkVEw9ihuE5ErTGxh1DMdwg7Gp8yLpu6DtxPyMRy
bGdMLDrHyN9OkXW2labeNgGKcPnX7N1Vx+DvjlROnhEuezd9MyEwnhnhvPWN
S1TrCQ9Lp207DnyAX4VSmmS1RLP8nHSYR/wzaIvJZPQMXRZzk3e69LHBrZmR
l6vQzUHrU7djXurn8oKKat6IFSrMb4Zl6sZAXmZFGjt5s4q+3v5zqYrtrLjo
GNaXVmewgwpWw3kdggptK0fa3Z6Z35IXx4KryJkhqKhtpaLbMgcWPuwQC0yJ
gW7Ic448na7L6LmJyBIaNlp+Y/T1625HP4fln2JlpkM7VtNCzetomeZNf6UG
wfRnlJE2kpz10zCggRN4+bd3xCeh62RU1jSeO4zre6zoWTg42XIm05F/gMIR
Xb9E0YnDUE7QkFqtsy6nqfX38jFvc3zKyGDcdLvwxBd87i+GPsiPk6vWV2yX
x81ZC1pgYfuaTicMXFVtqmuYhZmXMGvrF7eM1pUOezkvJ/bjHjfaHbERjPwX
nT+wxM32oJu6XKsmLjfey1o9be08pCynOM7LB46/+jtpkSD9WmqKvNpAGfbn
LZRRDwADk8HoYJ54KIN6VK9jrrI9kNnuOtYwwI1+QFzzJBdKy2wQAy3PxURs
9ntyltD42d80G3LcqcGbZA5zQokviSv7OV+sfxCFuCSSMzPSFyudFBNk3kmx
/rdwUmTf1klR5k2cBJZOKjuC8ErbCZUlTQD34aXQTBB8LT4TVLwhSBO1rgXf
dU2u4pmunuJvkPaSAbKXxlXJ4awioiwlh7JmIEtZBbKUHMgSMJbCftL+kR0f
vYCdBUWI9b2gsIGUISupUpSWwCkJh4Ui4KdFNhEyZdzpVF3kztBRxvoMA5bz
chi0WW0GdzazzmBNxqutNCEBMFvYKsCUjLu2kjtDJJvNTZEHZ8TcUWYDKDJ6
SwCwQNfN1ehWYDPNFQg2mU7NpvyeXU+o6TiWJN7C9lk6jZWPrC4i8i98+ABZ
oSgfeaWUWaWMbX8Yje17YiHhkIlLEaHWrUsPOtemlWIV6xPDd/uCBpbBcXTI
q0WSWBlSKySjkETjg4xNzue0T35kpO8oWlojyIjSxoPIvEaQ+O2MFBIaI3Ay
LnAX2/r14PQtWiU71b+qVXLB3VolV/HmrTLRurZVsluvUgNTjOXWu/QKBH5P
7kBcvzz+uPiaX38seb/uyuQZbDJBZdY9xVuNg5qKrfgwT5y70DjAQuBMpZcs
/mywgJUpsOE9vacWGynx1CMpUn4IXDzJD21qj2U++/G8zv7ziC/z8uGYYAmc
5kqgyL8Ok9hWZU3D6KoyRpzXLh4ROiP4QX57wMInhF8U4vB34DagY/hh/0RY
QMduBPgbBRMC964/hGDEQsEhIluZ2JMygI5nB6SlpcJvFUFyR3CwUMSwD6zU
TV1n/fy6++0Qceu6ol6M+2uLOXcGW1SblDSLSsuLAhkmQUgwz++J9xNoALeI
uyfTIKS2T2XARgZ+QMFmABhJ3OGXNjPpCYgXkY3uv7XfosNL+xdivp1aGLro
D23EGS++iRMlX9vERB1v2MVyate2sVqjxs5w7CsZk/rX615/gLP06lOvmz9S
jYk3xTYR+yG5cyNclG3KIj/Fueqx+/wHYvEoxNNVjGlqsGzJkzeejLaSyB0z
Ttf6Rh6nhBvk2ZQMNzDH/ovYeWfDw+898ZHzf0eu205wGgAA
---1463811839-15845461-1032414882=:18297--
