Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793562561;
	b=xxJvzkS7oB3XZvMINNbwckLeNuO9kDaLKfJ9kw/bjZ+6ulBjSWvXDIoA36qk3HwdakVp
	 0jGOYt3qwX/X0Mr1X1hefKGF35Gb52AU2Gqhs4YrI3K7lG7FA2Rn+n7yHwSrOFw7IE+lh
	 z5/KuJ3F9x3PLXCKk/HjoANyguRa6RB/N9vRtAK+AOcPZHN5kESUjBwR4ByHV7aa6+Eoc
	 LlanGXNklBqaLb+qnqU2PIS3tRVgFyIhYoKqKIG9N+mFl+1N18rGAhvO3hVw2BHb77vWb
	 Iqd7tdZKlfYS0LJQxWojPljPDWmUqu5poLLKefkbys+vae6gER9SJryB381epUKDCEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793562561;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=PxdNaGHDHUVp7+fj88DrVg9YZakmDLcZIphtdalVV50=;
	b=kbAfFFiJFIpSA2BFCwl1haXsl3m1o6B6ZtOIlUnkXb4f+PAojptRtBAtxPUjB1X2SGL9
	 uSlzcP4/KzAA5VsKdfYO7GAzOi1Q3CwkozvSsoqaOMCiX3zQl1779x6HvISZscT1WyMT0
	 wDNxZM7acOXdk/kL3AUSLBR7SJz0arVkKfCexS+fNTkxgVBIpS+ZFUQKbXc7PQlVFfPZt
	 cOQmo6yrfP5hjakNjic1OwqeyS2G4Nr3YOdMhie/yVaDFVv4AbMfns4lOzOUNECr8xeMO
	 /Az4ZvrrC+MOq+F3DwiqENMNEr5s8vTUK+WkBs53MmsA9LEVyZmN/ZDbYJf1rM35gmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KNjQHat7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD24C606A33B;
	Sun,  1 Nov 2026 19:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KNjQHat7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A1561F00A02;
	Sun,  1 Nov 2026 19:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793562560;
	bh=PxdNaGHDHUVp7+fj88DrVg9YZakmDLcZIphtdalVV50=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=KNjQHat7nj/oIX/Fl8PWM/NTpFFDxz+zqLs/scUUeHXn5HDt/0jxvur9/WCwrW18o
	 CE6fhcV+jlcjO0WaTX7W1iqhUraKyUr8ju+0Fj+p4qeXNgDhge4KsqBfaptE28ok77
	 wZsBasuV4ta9QcOyuuqa5wQ377B0+lvW1IuL2C0PbtmhLHd09MH1DXG+HCz7CwlNBR
	 ih+ZClcBeQ7EZge304jeZepga7ngM9fJBNYbXE4khBAybxsl0kEPDV6LSDvmBsZWkv
	 NY6iUvG/GuHdJtU8vlyKTK1nkXKJC27rCfap+Nk3Pdwoe4jV8Ja/cThpmcQy9+5yux
	 hesdXH8FNB/gA==
Subject: Re: [PATCH net v3 3/3] selftests: net: add tests for saddr, anycast
 and loopback subnets
From: netdev-bot+sashiko@kernel.org
To: ihuguet@riseup.net
Cc: ast@kernel.org, andrew+netdev@lunn.ch, andrii@kernel.org,
 daniel@iogearbox.net, dsahern@kernel.org, davem@davemloft.net,
 eddyz87@gmail.com, edumazet@kernel.org, fw@strlen.de, idosch@nvidia.com,
 kuba@kernel.org, memxor@gmail.com, ncardwell@google.com, pablo@netfilter.org,
 pabeni@redhat.com, shuah@kernel.org, willemdebruijn.kernel@gmail.com,
 bpf@vger.kernel.org, leitao@debian.org, coreteam@netfilter.org,
 emil@etsalapatis.com, fmancera@suse.de, ihor.solodrai@linux.dev,
 jlayton@kernel.org, jolsa@kernel.org, joe@dama.to, john.fastabend@gmail.com,
 zirajs7@gmail.com, kees@kernel.org, kuniyu@google.com, leon.hwang@linux.dev,
 lirongqing@baidu.com, linux-kselftest@vger.kernel.org, martin.lau@linux.dev,
 netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, phil@nwl.cc,
 tpluszz77@gmail.com, bigeasy@linutronix.de, horms@kernel.org, song@kernel.org,
 sdf@fomichev.me, willemb@google.com, luoxuanqiang@kylinos.cn,
 yonghong.song@linux.dev, ihuguet@redhat.com, dcaratti@redhat.com
Date: Sun, 01 Nov 2026 19:49:17 +0000
Message-ID: <179356255762.3131.11497685261734303637@kernel.org>
In-Reply-To: <20261028191103.623156-4-ihuguet@riseup.net>
References: <20261028191103.623156-4-ihuguet@riseup.net>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 11 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 4 · Low: 7

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The IPv6 '*_table' tests in loopback_subnet.sh are set up
  wrong and can never pass.
- [Medium] ip_saddr.sh can hang indefinitely if the ./ip_saddr server
  helper is not running.
- [Medium] selftests: net: ip_saddr hdrincl tests never exercise
  FLOWI_FLAG_ANYSRC check
- [Medium] selftests: net: ip_saddr IPV6_PKTINFO bypasses routing saddr
  check in UDPv6 tests
- [Low] Two error messages in tools/testing/selftests/net/ip_saddr.c name
  the wrong argument or socket option.
- [Low] In test_remove_addr_tcp_udp() and test_expire_addr_tcp_udp(),
  wait_addr_missing() runs inside an `ip netns exec $ns_cli bash -c…
- [Low] test_foreign_addr_udp() (ip_saddr.sh:401) finds the client's UDP
  port with `ss -uanp | grep "pid=$BASHPID,fd=3"`.
- [Low] parse_tcp_udp_args() uses 0 to mean 'no sync file' (`*out_sync_fd
  = 0;`), and sync_wait() checks `if (sync_fd && read(...))`.
- [Low] parse_hdrincl_args() ignores the return value of inet_pton().
- [Low] In test_expire_addr_*_{tcp,udp}_*, setup_test_tcp_udp() adds
  SENDER_ADDR with `preferred_lft 1 valid_lft 1` before the client has…
- [Low] selftests: net: missing sockaddr cast in
  send_or_receive_hdrincl()

--

selftests: net: add tests for saddr, anycast and loopback subnets

This adds selftests for source address validation of outgoing IPv4/IPv6
TCP, UDP and HDRINCL raw packets: ip_saddr.sh drives a C helper,
ip_saddr.c. It also adds ipv6_anycast.sh for subnet-router anycast and
loopback_subnet.sh for AnyIP loopback subnets. The loopback cases that
use a non-local table are marked xfail.

> diff --git a/tools/testing/selftests/net/ip_saddr.c b/tools/testing/selftests/net/ip_saddr.c
> new file mode 100644
> index 0000000000000..ed9b0a360b281
> --- /dev/null
> +++ b/tools/testing/selftests/net/ip_saddr.c
> @@ -0,0 +1,557 @@

[ ... ]

> +static void parse_tcp_udp_args(int argc,
> +			       char *argv[],
> +			       int *out_port,
> +			       bool *out_transparent,
> +			       int *out_sync_fd)
> +{
> +	if (argc < 5) {
> +		fprintf(stderr, "Expected more arguments");
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	*out_port = atoi(argv[3]);
> +
> +	if (strncmp(argv[4], "transparent", strlen("transparent")) == 0) {
> +		*out_transparent = true;
> +	} else if (strncmp(argv[4], "normal", strlen("normal")) == 0) {
> +		*out_transparent = false;
> +	} else {
> +		fprintf(stderr, "Valid values for arg3: normal, transparent");

[Severity: Low]
This isn't a bug, but this message says arg3 while the code checks
argv[4]. parse_gral_args() calls argv[1] arg1, so argv[3] (the port)
is arg3. Should this say arg4?

There is a similar mismatch in create_sock_ipv6():

	if (setsockopt(sk, IPPROTO_IPV6, IPV6_RECVPKTINFO, &opt, sizeof(opt))) {
		perror("Failed to set IPV6_PKTINFO");

The code sets IPV6_RECVPKTINFO, but the message names IPV6_PKTINFO.

> +		exit(EXIT_FAILURE);
> +	}
> +
> +	*out_sync_fd = 0;

[Severity: Low]
The shipped script can't trigger this, but is 0 a safe "no sync file"
value? sync_wait() later does:

	if (sync_fd && read(sync_fd, buff, sizeof(buff) - 1) < 0) {

If the helper starts with stdin closed, open(argv[5]) could return fd 0,
and the FIFO wait would be skipped without any error.

ip_saddr.sh always starts the helper as a background job, so stdin is
/dev/null and fd 0 is never free. This only matters when the helper is
run by hand. Using -1 as the unset value would avoid the ambiguity.

> +	if (argc > 5 && strlen(argv[5]) > 0) {
> +		*out_sync_fd = open(argv[5], O_RDWR);
> +		if (*out_sync_fd < 0) {
> +			perror("Failed to open sync file");
> +			exit(EXIT_FAILURE);
> +		}
> +	}
> +}

[ ... ]

> +	*out_send_msg = argc < 4 ? false : true;
> +	if (*out_send_msg && is_ipv6) {
> +		inet_pton(AF_INET6, argv[3], out_local_addr);
> +		inet_pton(AF_INET6, argv[4], out_peer_addr);
> +	} else if (*out_send_msg && !is_ipv6) {
> +		inet_pton(AF_INET, argv[3], out_local_addr);
> +		inet_pton(AF_INET, argv[4], out_peer_addr);
> +	}

[Severity: Low]
The inet_pton() return values are ignored here. If argv[3] or argv[4] is
not a valid address for the chosen family, would the uninitialized
local_addr and peer_addr unions from main() end up in the crafted IP
header and in the sendto() destination?

Every caller in ip_saddr.sh passes valid, hard-coded addresses, so this
only affects manual runs of the helper.

> diff --git a/tools/testing/selftests/net/ip_saddr.sh b/tools/testing/selftests/net/ip_saddr.sh
> new file mode 100755
> index 0000000000000..9345b743afd0b
> --- /dev/null
> +++ b/tools/testing/selftests/net/ip_saddr.sh
> @@ -0,0 +1,575 @@

[ ... ]

> +test_remove_addr_tcp_udp() {
> +	local test_name="$1"
> +	local ipvx="$2"
> +	local proto="$3"
> +	local sock_type="$4"
> +	local srv_msg
> +
> +	setup_test_tcp_udp "$ipvx" "$proto" "$sock_type" "$SRV_SYNC_FILE"
> +	srv_msg="$(ip netns exec $ns_cli bash -c "
> +                        exec 3<>'/dev/$proto/${SENDER_ADDR%/*}/$PORT'
> +                        [ '$proto' = 'udp' ] && echo 'x' >&3
> +                        ip -n $ns_srv addr del '$SENDER_ADDR' dev eth0
> +                        wait_addr_missing '$ns_srv' eth0 '$SENDER_ADDR'

[Severity: Medium]
Do the hdrincl variants ever reach the source address check they are
meant to cover? create_sock_ipv4_hdrincl() and
create_sock_ipv6_hdrincl() bind the raw socket to INADDR_ANY and
in6addr_any. send_or_receive_hdrincl() then calls sendto() without any
control message, so the sender address only exists in the crafted
header inside buff.

raw_sendmsg() and rawv6_sendmsg() do the route lookup before
raw_send_hdrinc() and rawv6_send_hdrinc() copy that header in. The
flow's saddr comes from inet->inet_saddr / np->saddr, or from a
PKTINFO cmsg if one is passed. Here it is unspecified.

The lookup therefore selects an address that is still configured, such
as CLI_ADDR. ip_route_output_key_hash_rcu() and ip6_dst_lookup_tail()
never see the removed, expired or foreign address.

As a result test_remove_addr_*_hdrincl, test_expire_addr_*_hdrincl and
test_foreign_addr_*_hdrincl pass whether or not FLOWI_FLAG_ANYSRC is
set for IP_HDRINCL and IPV6_HDRINCL sockets.

The previous patch changes rawv6_sendmsg() to set
fl6.flowi6_flags = inet_sk_flowi_flags(sk). That change is not covered
at all, and these tests would still pass if it were dropped.

Would it work to bind the client raw socket to SENDER_ADDR before the
address is removed or expires? Another option is to pass the sender
address in an IP_PKTINFO / IPV6_PKTINFO cmsg. For IPv6 the cmsg
approach would also need something like IPV6_FREEBIND, because
ip6_datagram_send_ctl() rejects a non-local ipi6_addr otherwise.

[Severity: Low]
Is a wait_addr_missing() timeout lost here? The function runs in the
bash -c child shell, and it reports failure only through RET and its
return status:

	RET=$ksft_fail
	return 1

RET is set only in the child. ksft_fail isn't exported, so it expands to
an empty string there. The return status is ignored, and the script goes
on to write the FIFO.

If the address is still present after the timeout, could the transparent
variants report OK even though the address was never invalidated? For
those variants set_test_result() only checks that a message arrived.

The call in test_expire_addr_tcp_udp() has the same problem. The hdrincl
variants call wait_addr_missing() in the main shell, so they are not
affected.

> +                        echo 'x' > '$SRV_SYNC_FILE'

[Severity: Medium]
Can this hang the whole script if the ./ip_saddr helper is not running?

Opening a FIFO for writing blocks until something opens it for reading.
The only process that ever opens $SRV_SYNC_FILE is the helper, in
parse_tcp_udp_args():

	*out_sync_fd = open(argv[5], O_RDWR);

setup_test_tcp_udp() doesn't check that the helper started. Also,
wait_local_port_listen() in lib.sh just leaves its loop without
returning a failure:

	for i in $(seq 10); do
		if ip netns exec "${listener_ns}" awk '{print $2" "$4}' \
		   /proc/net/"${protocol}"* | grep -q "${pattern}"; then
			break
		fi
		sleep 0.1
	done

The helper can exit early, for example when it wasn't built, or when
socket, setsockopt, bind, listen, accept or recvmsg fails and it calls
exit(EXIT_FAILURE). In that case this echo blocks in open() forever,
because timeout 2s only wraps the cat that follows.

cleanup_test and log_test then never run. The remaining tests are lost
until the kselftest runner timeout kills the script.

test_expire_addr_tcp_udp() has the same write.

Would it help to keep the FIFO open in the script (for example
exec 4<>"$SRV_SYNC_FILE" in setup()), wrap the write in timeout, and
check that the helper actually started?

> +                        timeout 2s cat <&3
> +                        exec 3<&-
> +                ")"

[ ... ]

> +test_expire_addr_tcp_udp() {
> +	local test_name="$1"
> +	local ipvx="$2"
> +	local proto="$3"
> +	local sock_type="$4"
> +	local srv_msg
> +
> +	setup_test_tcp_udp "$ipvx" "$proto" "$sock_type" "$SRV_SYNC_FILE" preferred_lft 1 valid_lft 1

[Severity: Low]
Can the 1 second lifetime run out before the client connects or sends
its UDP trigger? setup_test_tcp_udp() adds the address as its last step:

	ip -n $ns_srv addr add "$SENDER_ADDR" dev eth0 $nodad $addr_args

The lifetime starts counting at that point. The client still has to run
ip netns exec, start bash -c, and do exec 3<>/dev/$proto/... before its
SYN or datagram reaches the server.

On a slow or heavily loaded machine, the client's packet could arrive
after the address is gone and be dropped. The normal variants would then
pass without exercising the saddr check, and the transparent variants
would fail for unrelated reasons.

Would it be more robust to add the address with a long lifetime and
shorten it with ip addr change ... valid_lft 1 once the connection is up
and the server has received the trigger?

The remove variants have a similar but much smaller gap. The address is
deleted right after the UDP trigger is sent, with no acknowledgement
from the server.

> +	srv_msg="$(ip netns exec $ns_cli bash -c "
> +                        exec 3<>'/dev/$proto/${SENDER_ADDR%/*}/$PORT'
> +                        [ '$proto' = 'udp' ] && echo 'x' >&3

[ ... ]

> +test_foreign_addr_udp() {
> +	local test_name="$1"
> +	local ipvx="$2"
> +	local sock_type="$3"
> +	local srv_msg
> +
> +	setup_test_tcp_udp "$ipvx" "udp" "$sock_type" ""
> +	srv_msg="$(ip netns exec $ns_cli bash -c "
> +                        exec 3<>'/dev/udp/${FOREIGN_ADDR%/*}/$PORT'
> +                        cli_port=\"\$(ss -uanp | grep \"pid=\$BASHPID,fd=3\" | awk '{print \$4}' | sed 's/.*://')\"

[Severity: Low]
Does $BASHPID here refer to the shell that owns fd 3? Each part of the
pipeline is forked before its words are expanded. So $BASHPID becomes
the PID of the process that runs grep, not the bash -c shell that
opened the socket.

The match works only because grep inherits fd 3 and ss -p happens to
see grep's process during its /proc scan. If it doesn't, cli_port is
empty and maybe_chg_saddr_dport() ends up doing:

	peer_addr->sin_port = htons(atoi(portstr));

with an empty portstr. The reply then goes to port 0 and sendmsg()
fails. The transparent foreign tests would fail spuriously, and the
normal ones would pass without testing anything.

Would using $$ (the PID of the bash -c shell), or filtering on the
connected peer address, find the socket reliably?

> +                        echo \"${FOREIGN_ADDR%/*} \$cli_port\" >/dev/udp/${SENDER_ADDR%/*}/$PORT

[ ... ]

> diff --git a/tools/testing/selftests/net/loopback_subnet.sh b/tools/testing/selftests/net/loopback_subnet.sh
> new file mode 100755
> index 0000000000000..c846e65f01f3b
> --- /dev/null
> +++ b/tools/testing/selftests/net/loopback_subnet.sh
> @@ -0,0 +1,135 @@

[ ... ]

> +setup_loopback_subnets() {
> +        local rt_table="${1:-local}"
> +
> +        ip -n $ns_srv route add local "$LO_SUBNET4" dev lo table "$rt_table"
> +        ip -n $ns_srv route add local "$LO_SUBNET6" dev lo table "$rt_table"
> +        if [[ $rt_table != local && $rt_table != 255 ]]; then
> +                ip -n $ns_srv rule add from all lookup "$rt_table"

[Severity: Medium]
Does this create an IPv6 rule? With no -6 and a "from all" selector, ip
rule defaults to AF_INET, so only an IPv4 rule pointing at table 200 is
added.

The IPv6 local route for $LO_SUBNET6 goes into table 200 just above.
fib6_rules_net_init() only installs default AF_INET6 rules for the
local and main tables, so no IPv6 lookup reaches table 200. That means
test_loopback_subnet_from_localhost_ipv6_table and
test_loopback_subnet_from_remote_ipv6_table cannot pass on any kernel.

cleanup_loopback_subnets() deletes only the IPv4 rule in the same way.

The commit message says:

    The *_table tests in loopback_subnet.sh are marked as xfail because
    currently loopback subnets are only working fine in the local table.
    As this is unrelated to the current main patch, I plan to address it in
    a different patch series.

The IPv6 variants never reach the case described there. With xfail, a
real IPv6 regression in a non-local table would still be reported as an
expected failure. These tests would also keep failing after the stated
limitation is fixed.

The previous patch's IPv6 source address check falls back to
fib6_lookup(), which follows policy rules. That makes this path relevant
to the main patch.

Would adding ip -n $ns_srv -6 rule add from all lookup "$rt_table", plus
the matching -6 rule del, make the IPv6 table tests meaningful? Other
selftests in this directory, such as fib_rule_tests.sh and
fcnal-test.sh, pass -6 explicitly for IPv6 rules.

> +        fi
> +}

[ ... ]

> @@ -0,0 +1,557 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <stdbool.h>
> +#include <unistd.h>
> +#include <fcntl.h>
> +#include <arpa/inet.h>
> +#include <sys/socket.h>
> +#include <netinet/ip.h>
> +#include <netinet/ip6.h>
> +
> +#define MESSAGE "Hello!\n"
> +
> +union addr46 {
> +	struct in_addr addr4;
> +	struct in6_addr addr6;
> +};
> +
> +/* -----------------------------------------------
> + * Functions for the TCP and UDP tests:
> + * - Create a STREAM or DGRAM socket, optionally with the TRANSPARENT sockopt
> + * - Act only as server, the companion script will act as client
> + * - Wait for a TCP connection or UDP datagram from the client
> + * - Wait until the client sends a sync message (via FIFO file) to continue
> + *   (the client may need to do some actions before the next step)
> + * - Send a message to the client
> + * ------------------------------------------------
> + */
> +static int create_sock_ipv6(int proto, int port, bool transparent)
> +{
> +	struct sockaddr_in6 address;
> +	int sk, opt;
> +
> +	sk = socket(AF_INET6, proto, 0);
> +	if (sk < 0) {
> +		perror("Failed to create socket");
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	opt = 1;
> +	if (setsockopt(sk, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt))) {
> +		perror("Failed to set SO_REUSEADDR");
> +		exit(EXIT_FAILURE);
> +	}
> +	opt = 0;
> +	if (setsockopt(sk, IPPROTO_IPV6, IPV6_V6ONLY, &opt, sizeof(opt))) {
> +		perror("Failed to set IPV6_V6ONLY");
> +		exit(EXIT_FAILURE);
> +	}
> +	opt = 1;
> +	if (setsockopt(sk, IPPROTO_IPV6, IPV6_RECVPKTINFO, &opt, sizeof(opt))) {
> +		perror("Failed to set IPV6_PKTINFO");
> +		exit(EXIT_FAILURE);
> +	}
> +	opt = 1;
> +	if (transparent &&
> +	    setsockopt(sk, IPPROTO_IPV6, IPV6_TRANSPARENT, &opt, sizeof(opt))) {
> +		perror("Failed to set IPV6_TRANSPARENT");
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	memset(&address, 0, sizeof(address));
> +	address.sin6_family = AF_INET6;
> +	address.sin6_addr = in6addr_any;
> +	address.sin6_port = htons(port);
> +
> +	if (bind(sk, (struct sockaddr *)&address, sizeof(address))) {
> +		perror("Failed to bind");
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	return sk;
> +}
> +
> +static int create_sock_ipv4(int proto, int port, bool transparent)
> +{
> +	struct sockaddr_in address;
> +	int sk, opt;
> +
> +	sk = socket(AF_INET, proto, 0);
> +	if (sk < 0) {
> +		perror("Failed to create socket");
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	opt = 1;
> +	if (setsockopt(sk, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt))) {
> +		perror("Failed to set SO_REUSEADDR");
> +		exit(EXIT_FAILURE);
> +	}
> +	opt = 1;
> +	if (setsockopt(sk, IPPROTO_IP, IP_PKTINFO, &opt, sizeof(opt))) {
> +		perror("Failed to set IP_PKTINFO");
> +		exit(EXIT_FAILURE);
> +	}
> +	opt = 1;
> +	if (transparent &&
> +	    setsockopt(sk, IPPROTO_IP, IP_TRANSPARENT, &opt, sizeof(opt))) {
> +		perror("Failed to set IP_TRANSPARENT");
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	memset(&address, 0, sizeof(address));
> +	address.sin_family = AF_INET;
> +	address.sin_addr.s_addr = htonl(INADDR_ANY);
> +	address.sin_port = htons(port);
> +
> +	if (bind(sk, (struct sockaddr *)&address, sizeof(address))) {
> +		perror("Failed to bind");
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	return sk;
> +}
> +
> +static void sync_wait(int sync_fd)
> +{
> +	uint8_t buff[256];
> +
> +	if (sync_fd && read(sync_fd, buff, sizeof(buff) - 1) < 0) {
> +		perror("Failed to read from sync file");
> +		exit(EXIT_FAILURE);
> +	}
> +}
> +
> +static void wait_and_send_tcp(int sk, int sync_fd)
> +{
> +	int con;
> +
> +	if (listen(sk, 5) < 0) {
> +		perror("Failed to listen");
> +		exit(EXIT_FAILURE);
> +	}
> +	con = accept(sk, NULL, NULL);
> +	if (con < 0) {
> +		perror("Failed to accept");
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	sync_wait(sync_fd);
> +
> +	if (send(con, MESSAGE, strlen(MESSAGE), 0) < 0) {
> +		perror("Failed to send");
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	close(con);
> +}
> +
> +static void maybe_chg_saddr_dport(char *data, struct msghdr *msg)
> +{
> +	struct in6_addr local_addr6;
> +	struct in_addr local_addr4;
> +	int cmsg_level, cmsg_type;
> +	struct cmsghdr *cmsg;
> +	size_t datalen;
> +	char *portstr;
> +
> +	portstr = strchr(data, ' ');
> +	if (!portstr)
> +		return;
> +
> +	// remove trailing LF and split into 2 strs
> +	datalen = strlen(data);
> +	if (datalen > 0 && data[datalen - 1] == '\n')
> +		data[datalen - 1] = '\0';
> +	*(portstr++) = '\0';
> +
> +	// get the new saddr and dport
> +	if (inet_pton(AF_INET, data, &local_addr4) == 1) {
> +		struct sockaddr_in *peer_addr;
> +
> +		peer_addr = (struct sockaddr_in *)msg->msg_name;
> +		peer_addr->sin_port = htons(atoi(portstr));
> +		cmsg_level = IPPROTO_IP;
> +		cmsg_type = IP_PKTINFO;
> +	} else if (inet_pton(AF_INET6, data, &local_addr6) == 1) {
> +		struct sockaddr_in6 *peer_addr;
> +
> +		peer_addr = (struct sockaddr_in6 *)msg->msg_name;
> +		peer_addr->sin6_port = htons(atoi(portstr));
> +		cmsg_level = IPPROTO_IPV6;
> +		cmsg_type = IPV6_PKTINFO;
> +	} else {
> +		return;
> +	}
> +
> +	for (cmsg = CMSG_FIRSTHDR(msg); cmsg; cmsg = CMSG_NXTHDR(msg, cmsg)) {
> +		if (cmsg->cmsg_level != cmsg_level ||
> +		    cmsg->cmsg_type != cmsg_type) {
> +			continue;
> +		}
> +		if (cmsg->cmsg_level == IPPROTO_IP &&
> +		    cmsg->cmsg_type == IP_PKTINFO) {
> +			struct in_pktinfo *pi;
> +
> +			pi = (struct in_pktinfo *)CMSG_DATA(cmsg);
> +			pi->ipi_addr = local_addr4;
> +			pi->ipi_spec_dst = local_addr4;
> +			break;
> +		}
> +		if (cmsg->cmsg_level == IPPROTO_IPV6 &&
> +		    cmsg->cmsg_type == IPV6_PKTINFO) {
> +			struct in6_pktinfo *pi;
> +
> +			pi = (struct in6_pktinfo *)CMSG_DATA(cmsg);
> +			pi->ipi6_addr = local_addr6;
> +			break;
> +		}
> +	}
> +}
> +
> +static void wait_and_send_udp(int sk, int sync_fd)
> +{
> +	uint8_t data_buff[256], ctrl_buff[256];
> +	ssize_t nbytes;
> +	union {
> +		struct sockaddr_in addr4;
> +		struct sockaddr_in6 addr6;
> +	} peer_addr;
> +	struct iovec iov = {
> +		.iov_base = data_buff,
> +		.iov_len = sizeof(data_buff) - 1,
> +	};
> +	struct msghdr msg = {
> +		.msg_name = &peer_addr,
> +		.msg_namelen = sizeof(peer_addr),
> +		.msg_iov = &iov,
> +		.msg_iovlen = 1,
> +		.msg_control = ctrl_buff,
> +		.msg_controllen = sizeof(ctrl_buff),
> +	};
> +
> +	nbytes = recvmsg(sk, &msg, 0);
> +	if (nbytes < 0) {
> +		perror("Failed to receive");
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	// The "test_foreign_addr_*" tests needs us to reply to the same address
> +	// but different port, and also from a different local address. The new
> +	// saddr and dport are received in the previous message with the format
> +	// "new_source_address new_dest_port"
> +	data_buff[nbytes] = '\0';
> +	maybe_chg_saddr_dport((char *)data_buff, &msg);
> +
> +	sync_wait(sync_fd);
> +
> +	// Change the data, but keep the same ancillary data so that we use the
> +	// same addresses as we received.
> +	iov.iov_base = MESSAGE;
> +	iov.iov_len = strlen(MESSAGE);
> +
> +	if (sendmsg(sk, &msg, 0) < 0) {
> +		/* Contrary to the TCP case, as UDP doesn't keep a "connection",
> +		 * the test cases where the source address is not configured in
> +		 * the host return an error here. It is expected, ignore it.
> +		 */
> +	}
> +}
> +
> +/* -----------------------------------------------
> + * Functions for the HDRINCL tests:
> + * - Create a RAW socket with the HDRINCL sockopt
> + * - If acting as server, wait for incoming data and print it
> + * - If acting as client, craft a packet with the saddr and daddr from the args
> + *   and send it.
> + * ------------------------------------------------
> + */
> +static int create_sock_ipv4_hdrincl(void)
> +{
> +	struct sockaddr_in address;
> +	int sk, opt;
> +
> +	sk = socket(AF_INET, SOCK_RAW, IPPROTO_RAW);
> +	if (sk < 0) {
> +		perror("Failed to create socket");
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	opt = 1;
> +	if (setsockopt(sk, IPPROTO_IP, IP_HDRINCL, &opt, sizeof(opt)) < 0) {
> +		perror("Failed to set IP_HDRINCL");
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	memset(&address, 0, sizeof(address));
> +	address.sin_family = AF_INET;
> +	address.sin_addr.s_addr = htonl(INADDR_ANY);
> +
> +	if (bind(sk, (struct sockaddr *)&address, sizeof(address))) {
> +		perror("Failed to bind");
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	return sk;
> +}
> +
> +static int create_sock_ipv6_hdrincl(void)
> +{
> +	struct sockaddr_in6 address;
> +	int sk, opt;
> +
> +	sk = socket(AF_INET6, SOCK_RAW, IPPROTO_RAW);
> +	if (sk < 0) {
> +		perror("Failed to create socket");
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	opt = 1;
> +	if (setsockopt(sk, IPPROTO_IPV6, IPV6_HDRINCL, &opt, sizeof(opt)) < 0) {
> +		perror("Failed to set IPV6_HDRINCL");
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	memset(&address, 0, sizeof(address));
> +	address.sin6_family = AF_INET6;
> +	address.sin6_addr = in6addr_any;
> +
> +	if (bind(sk, (struct sockaddr *)&address, sizeof(address))) {
> +		perror("Failed to bind");
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	return sk;
> +}
> +
> +size_t create_packet_ipv6(uint8_t *buff,
> +			  struct in6_addr saddr,
> +			  struct in6_addr daddr)
> +{
> +	struct ip6_hdr *iph = (struct ip6_hdr *)buff;
> +	uint8_t *data = (uint8_t *)(buff + sizeof(struct ip6_hdr));
> +
> +	// header
> +	iph->ip6_flow = htonl((6 << 28) | (0 << 20) | 0);
> +	iph->ip6_plen = htons(sizeof(MESSAGE));
> +	iph->ip6_nxt = IPPROTO_RAW;
> +	iph->ip6_hops = 64;
> +	iph->ip6_src = saddr;
> +	iph->ip6_dst = daddr;
> +
> +	// data
> +	memcpy(data, MESSAGE, sizeof(MESSAGE));
> +
> +	return sizeof(struct ip6_hdr) + sizeof(MESSAGE);
> +}
> +
> +size_t create_packet_ipv4(uint8_t *buff,
> +			  struct in_addr saddr,
> +			  struct in_addr daddr)
> +{
> +	struct ip *iph = (struct ip *)buff;
> +	uint8_t *data = (uint8_t *)(buff + sizeof(struct ip));
> +
> +	// header
> +	iph->ip_hl = 5; // Header length (5 * 4 bytes = 20 bytes)
> +	iph->ip_v = 4;  // IPv4
> +	iph->ip_tos = 0;
> +	iph->ip_len = htons(sizeof(struct ip) + sizeof(MESSAGE));
> +	iph->ip_id = htons(12345);
> +	iph->ip_off = 0;
> +	iph->ip_ttl = 64;
> +	iph->ip_p = IPPROTO_RAW;
> +	iph->ip_src = saddr;
> +	iph->ip_dst = daddr;
> +	iph->ip_sum = 0;
> +
> +	// data
> +	memcpy(data, MESSAGE, sizeof(MESSAGE));
> +
> +	return sizeof(struct ip) + sizeof(MESSAGE);
> +}
> +
> +static void send_or_receive_hdrincl(int sk,
> +				    bool is_ipv6,
> +				    bool send_msg,
> +				    union addr46 *local_addr,
> +				    union addr46 *peer_addr)
> +{
> +	uint8_t buff[256];
> +	ssize_t msglen;
> +
> +	if (send_msg && is_ipv6) {
> +		struct sockaddr_in6 dest;
> +
> +		memset(&dest, 0, sizeof(dest));
> +		dest.sin6_family = AF_INET6;
> +		dest.sin6_addr = peer_addr->addr6;
> +		msglen = create_packet_ipv6(buff,
> +					    local_addr->addr6,
> +					    peer_addr->addr6);
> +		if (sendto(sk, buff, msglen, 0, &dest, sizeof(dest)) < 0) {

[Severity: Low]
Both sendto() calls in send_or_receive_hdrincl() pass &dest without a
cast. One is a struct sockaddr_in6 * and the other a
struct sockaddr_in *. The bind() calls in this file use the cast.

This relies on glibc declaring the address argument as a transparent
union, which it only does when __USE_GNU is in effect. Otherwise, for
example with musl, sendto() takes a const struct sockaddr *.

This then becomes an incompatible-pointer-types diagnostic, which
GCC 14 and newer treat as an error by default. Could both calls cast to
(struct sockaddr *)&dest like the bind() calls do?

> +			perror("Failed to send");
> +			exit(EXIT_FAILURE);
> +		}
> +	} else if (send_msg && !is_ipv6) {
> +		struct sockaddr_in dest;
> +
> +		memset(&dest, 0, sizeof(dest));
> +		dest.sin_family = AF_INET;
> +		dest.sin_addr = peer_addr->addr4;
> +		msglen = create_packet_ipv4(buff,
> +					    local_addr->addr4,
> +					    peer_addr->addr4);
> +		if (sendto(sk, buff, msglen, 0, &dest, sizeof(dest)) < 0) {
> +			perror("Failed to send");
> +			exit(EXIT_FAILURE);
> +		}
> +	} else {
> +		msglen = read(sk, buff, sizeof(buff) - 1);
> +		if (msglen < 0) {
> +			perror("Failed to read");
> +			exit(EXIT_FAILURE);
> +		}
> +		buff[msglen] = '\0';
> +
> +		// output the received message
> +		if (is_ipv6)
> +			printf("%s", buff);
> +		else if (msglen >= sizeof(struct ip))
> +			printf("%s", buff + sizeof(struct ip));
> +	}
> +}
> +
> +/* -----------------------------------------------
> + * Arguments parsing
> + * ------------------------------------------------
> + */
> +static void parse_gral_args(int argc,
> +			    char *argv[],
> +			    bool *out_is_ipv6,
> +			    int *out_proto)
> +{
> +	if (argc < 3) {
> +		fprintf(stderr, "Expected more arguments");
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	if (strncmp(argv[1], "ipv4", strlen("ipv4")) == 0) {
> +		*out_is_ipv6 = false;
> +	} else if (strncmp(argv[1], "ipv6", strlen("ipv6")) == 0) {
> +		*out_is_ipv6 = true;
> +	} else {
> +		fprintf(stderr, "Valid value for arg1: ipv4, ipv6");
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	if (strncmp(argv[2], "tcp", strlen("tcp")) == 0) {
> +		*out_proto = SOCK_STREAM;
> +	} else if (strncmp(argv[2], "udp", strlen("udp")) == 0) {
> +		*out_proto = SOCK_DGRAM;
> +	} else if (strncmp(argv[2], "raw", strlen("raw")) == 0) {
> +		*out_proto = SOCK_RAW;
> +	} else {
> +		fprintf(stderr, "Valid value for arg2: tcp, udp, raw");
> +		exit(EXIT_FAILURE);
> +	}
> +}
> +
> +static void parse_tcp_udp_args(int argc,
> +			       char *argv[],
> +			       int *out_port,
> +			       bool *out_transparent,
> +			       int *out_sync_fd)
> +{
> +	if (argc < 5) {
> +		fprintf(stderr, "Expected more arguments");
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	*out_port = atoi(argv[3]);
> +
> +	if (strncmp(argv[4], "transparent", strlen("transparent")) == 0) {
> +		*out_transparent = true;
> +	} else if (strncmp(argv[4], "normal", strlen("normal")) == 0) {
> +		*out_transparent = false;
> +	} else {
> +		fprintf(stderr, "Valid values for arg3: normal, transparent");
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	*out_sync_fd = 0;
> +	if (argc > 5 && strlen(argv[5]) > 0) {
> +		*out_sync_fd = open(argv[5], O_RDWR);
> +		if (*out_sync_fd < 0) {
> +			perror("Failed to open sync file");
> +			exit(EXIT_FAILURE);
> +		}
> +	}
> +}
> +
> +static void parse_hdrincl_args(int argc,
> +			       char *argv[],
> +			       bool is_ipv6,
> +			       bool *out_send_msg,
> +			       union addr46 *out_local_addr,
> +			       union addr46 *out_peer_addr)
> +{
> +	if (argc == 4) {
> +		fprintf(stderr, "Expected more arguments");
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	*out_send_msg = argc < 4 ? false : true;
> +	if (*out_send_msg && is_ipv6) {
> +		inet_pton(AF_INET6, argv[3], out_local_addr);
> +		inet_pton(AF_INET6, argv[4], out_peer_addr);
> +	} else if (*out_send_msg && !is_ipv6) {
> +		inet_pton(AF_INET, argv[3], out_local_addr);
> +		inet_pton(AF_INET, argv[4], out_peer_addr);
> +	}
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	union addr46 local_addr, peer_addr;
> +	bool is_ipv6, transparent, send_msg;
> +	int proto, port;
> +	int sync_fd;
> +	int sk;
> +
> +	parse_gral_args(argc, argv, &is_ipv6, &proto);
> +	if (proto != SOCK_RAW)
> +		parse_tcp_udp_args(argc, argv, &port, &transparent, &sync_fd);
> +	else
> +		parse_hdrincl_args(argc,
> +				   argv,
> +				   is_ipv6,
> +				   &send_msg,
> +				   &local_addr,
> +				   &peer_addr);
> +
> +	if (is_ipv6 && proto != SOCK_RAW)
> +		sk = create_sock_ipv6(proto, port, transparent);
> +	else if (!is_ipv6 && proto != SOCK_RAW)
> +		sk = create_sock_ipv4(proto, port, transparent);
> +	else if (is_ipv6 && proto == SOCK_RAW)
> +		sk = create_sock_ipv6_hdrincl();
> +	else // !is_ipv6 && proto == SOCK_RAW
> +		sk = create_sock_ipv4_hdrincl();
> +
> +	if (proto == SOCK_STREAM)
> +		wait_and_send_tcp(sk, sync_fd);
> +	else if (proto == SOCK_DGRAM)
> +		wait_and_send_udp(sk, sync_fd);
> +	else // SOCK_RAW
> +		send_or_receive_hdrincl(sk,
> +					is_ipv6,
> +					send_msg,
> +					&local_addr,
> +					&peer_addr);
> +
> +	close(sk);
> +	return 0;
> +}

[Severity: Medium]
Does the IPv6 normal UDP path ever reach the route lookup?
wait_and_send_udp() sends the reply with the IPV6_PKTINFO cmsg it
received, after maybe_chg_saddr_dport() may have rewritten ipi6_addr.

Because msg_controllen is non-zero, udpv6_sendmsg() first runs
ip6_datagram_send_ctl(). For a socket that can't do nonlocal binds,
that function checks ipi6_addr with ipv6_chk_addr_and_flags() and
ipv6_chk_acast_addr_src(). It returns -EINVAL when the address is not
configured.

This affects test_remove_addr_ipv6_udp_normal,
test_expire_addr_ipv6_udp_normal and test_foreign_addr_ipv6_udp_normal.
In each of them, sendmsg() fails during cmsg parsing, before
ip6_sk_dst_lookup_flow() and ip6_dst_lookup_tail() are reached.

The error is ignored here. So these tests pass the same way on a kernel
without the previous patch, and the new IPv6 source address check is
never exercised.

The IPv4 variants don't seem to have this problem. ip_cmsg_send() takes
ipi_spec_dst for IP_PKTINFO without validating it, and the address goes
on to the route lookup.

Could the IPv6 normal remove and expire variants send without the cmsg,
for example with the socket bound to SENDER_ADDR6 while it still
exists? The source would then come from np->saddr. The foreign variant
would probably need a different approach.

Printing the sendmsg() errno would also make it clearer which check
rejected the packet.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261028191103.623156-1-ihuguet%40riseup.net
