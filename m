From: Fabien COELHO <fabien@coelho.net>
Subject: date match
Date: Wed, 23 Apr 2003 10:47:07 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.53.0304231025160.31438@sablons.ensmp.fr>
Reply-To: Fabien COELHO <fabien@coelho.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="34246414-344365775-1051087627=:31438"
Cc: Fabrice MARIE <fabrice@netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Developpers <netfilter-devel@lists.netfilter.org>
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

--34246414-344365775-1051087627=:31438
Content-Type: TEXT/PLAIN; charset=US-ASCII


Hello Netfilter guys,

I wish to contribute a "date" match which enable rules based on dates.
Unlike Fabrice's "time" match which can be used for periodic patterns, the
date module just set simple start and stop dates.

For instance to enable something in April 2003 one can set:

	iptables ... -m date --date-start 2003:04 --date-stop 2003:05 ...

I need this match because I'm often asked to open our iptables filter for
some destination "temporarily", but this ends up as permanent rules as I
do not spend my time reviewing the configuration script...

>From a technical point of view, I could not get the time from the "stamp"
field in the "sk_buff" struct, as it seems to always be 0, so the time
relies on the do_gettimeofday kernel function, which may be quite time
consumming?

>From an English language point of view, I'm not sure the option names are
well chosen ("date-start", "date-stop", "epoch-start", "epoch-stop").
Maybe begin/end would be better than start/stop?

Moreover, I have no idea how to contribute the module to netfilter from a
practical point of view. The current situation is that it is a standalone
module which is compiled and installed on its own. I'm not really versed
in CVS/pom/patch/diff which looks the standard way to contribute a module.

The current module is attached. Its current status is "it works for me".

Thanks in advance for your comments, pointers and help,

have a nice day,

-- 
Fabien COELHO   _____   fabien@coelho.net   _____   http://www.coelho.net
--34246414-344365775-1051087627=:31438
Content-Type: APPLICATION/x-gtar; name="date-0.9alpha.tgz"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.53.0304231047070.31438@sablons.ensmp.fr>
Content-Description: 
Content-Disposition: attachment; filename="date-0.9alpha.tgz"

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
1I27jHpweB9TCcJfb9LGnEkpu/wGi1K/rzborD2D8H7MiTr4HdY8OJwxpsQp
zbnrhNzOvp7lTdcHUELn/a3ZdWqIbSa1qYUEJbwhu08J6KaQ9tKC6eEUggqE
MAzmFkHCm+odt0GLc2dxqcxdhgKk4pFr398ymR6v5DAxnqvgv5UvXR0KNRzD
YklnJYgMA3EXQuMAAkMj48EY4VCC+4kD+ppTUww8btXS1+jn/pVRxOeoiwIC
/xrliBnmXraiM0IpN4pA11R080TmlRdU9DyPGWXt19yx/QbiNdwnyUdEbvKR
0o18zgVK2oq6ks9oQvGIiJWQorjomrsxK15uoSSkrm99qP4nKnT/s29d8CFk
0gca4473v9bXG7PvfzW21mvL+58/ojxmqz2nyVIPqFyyulHfpL1utbZRbayz
2lazsdmsbzChAXbEPbaqPFYe42YhxPXXoiMx0CPsmDF5U/LP7irk+0bQA7p0
O70T9mP3qMteHxyxXw5Oj9hx9+QEdtPHyuOfukeDbt/s9I4gx1YncVSNI7tK
Vx+KaDMcF2yVa7zgkc89fcQth0ex3jA2jEZNf/a3Z2kH17exw6o6ZaBV5fkd
CiTltnAjI9+HOqZRYBDPPZMvisXVKWc5Jl7GVOkaJpsp7sX7vVeZkNg/TdU4
Ft6ZZfdUui7fT6OrLlSb/D23xwdWdaNhbFnIo3PABgcnUz2+pAOA3mAX02Wb
6T1STXpvVPwp7nn/rfQHP2OPkuyR6QbINEXJHyYgQc14bnnhCEbfxS6A/2xb
2T08fN3f2TsmDp1ZidvvVlbV2Urt3Qp7B7iOyAtHFkReOMMAUr1nKLs0Bg2q
v0Hv0t/gFZyd6GEUJEFyHaIi3/iBDrXnkRWO4OdBQwwzhGpJbXmuRQiRKnGP
C2rXh8HYTfRhZI25HgZ0KiN6hm4IqhuHER8CzOQOLtz2hX4WTPC25rrdgEYr
skdtFx2t3yEBPQeecvLGdFOpKK8NuyQ88Mr1HBtve8oG6Pm1Ech6oGg+Mez2
EyPA6tE8+Qjrkw8JtaShyo66O539Lo4AkZDxGmmCpfiCThoTEaTANmave0KE
2c1hwPJ3/3GgKKDmZhrZivxuAi/RG/xDRky+rmSPIE6Y9X1UqAxBxzP8GfmF
DJKMJifOqpoLQhwta2pOyWyltKru7mrgeqYps4bJ0GWgv/RunH/qpfQsn96J
g3W9I9/NoQfpd8fQyqZFT8OoECHV7A1SGbCxMWK6H+AVMiQbwV93r9xkhB7k
fmBZNHZ+enXa63fMVzvH3QHseNqrZabbbHVbUfJqgqkW3shIZ7t4QqTRdMbZ
5BewjWf4Bsi336FuHclMBwv8QD2foBjgli32pcHlMLbHLb+JpEf7Giv/B3wW
8DD5E4JBaPmB27B2rIzBeRlRf5a+9Vn604qiwEIMlLgc2x8vxUsI+kxiMJLz
j0zfZQZa2nIcqWFCMRXyeIgFTVsiwK8tpDmRSR5sjLv+/ufZ1hz+q28u3///
Q4rEf8IDBPqbAX/1zeZmrQj+lMEMuKOrCm55DLOeeHcBL4oseZ6vKEpvcHyy
0+8rSl1j3HETedovlzKEQLkrnxhfcPbPATTFkD68F+zSzZY9RWloGfLMo844
mQyHWQ9KNLIZhj89hoVyHZbCwHLE0PKvHXyQHH8LUJd1h564oqW5UlE2sG9w
gX93FPgevkqDiW1Kn8G6sYC/ui7aN1FY/AuFScSFdqaIcLYvXgJM+8/cUs1d
USH5789z8v0/XNHuwZsWFxC2sfWF+K9hG8Z/rVF/1tjA+IcOj9jmg0mUK3/x
+M/Zv/h22T2OAfasbWGO/2r7b25sNh6xhmHcoxS3lL+4/ZdlWZZlWZZlWZZl
WZZlWZZlWZZlWZZlWZZlWZbl/7f8F+rGV9EAUAAA

--34246414-344365775-1051087627=:31438--
