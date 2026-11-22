Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795382249;
	b=enWpcqL+vBVzBPNqzy1Jw35GVu+3HJMas1XkSabCzwWGwK8h3XumQ+y29tB6HU125+ux
	 6Br0sKXyfhL5FxdAsGWgz9aIQVppYkpmHrL4qkNkF8FAtVZHJA+KY5To77aMuofoBCmHv
	 fJ442ZDNreDCqE3kxW37Zy42rZ44aXNydrHHH9nSR/QCcu2jCMirI116SgobIPduAD/TZ
	 AbsBWzhTDF7B8w8EviHoE0EiDY5vukjufYQxVJXvEEUp1zE46cfK5eJBNIFGsKUw1ZpqT
	 NoBKxhOXuTG6vH0xYGiKbjMYXTisOYRcdx9j1F6Yj1TNpbFaXcyANFFdfDrMfEZ+Ejg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795382249;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=o0NKp8HiOP98FuBUmNxS8Y3b7MBHfe1gOi9fjsinfFY=;
	b=lwA10hyCXroObVDVXH+MHL5mjlVru32dCWP3Vx84aIAbD31RECIzlKti9+DpikcWCiwQ
	 pdzGXBmokVtuBHdhrAdvli1BspFQieil//mHZXSV1oVrkWxEE6USfhP0vvYUe8nUXfBWd
	 4RRDiGWef/MtiNI2mlL35MEvu5g+EkZdUD9YJFqg8MCZEibd4pYQ7fNobamdf66BrFhzV
	 51sCN24CCgCGG+/o+X6qkCTBd/lR418NCqHKuaAI4gOROAOKTXr8KdMjUi1cLPHO12wxe
	 PV50/UGm+TX2hDcd6VZMTFxs8ocD1jnqwONclVCG7+eldqgQGM5AZCz/2O7ZzT8icrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fuLw+ba5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA586606A31E;
	Sun, 22 Nov 2026 21:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fuLw+ba5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FD101F000F2;
	Sun, 22 Nov 2026 21:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795382249;
	bh=o0NKp8HiOP98FuBUmNxS8Y3b7MBHfe1gOi9fjsinfFY=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=fuLw+ba5nnp+s7zAFut5zjj87O8lowSNE/sOTamaaE3vy5HLQtIjKiV0dbl7WXZJa
	 /BegfcIoz9BIt4+RwOwuTLL4IEn95P+PneCjd1QkFyWGzL9b6GWzbjx8fW6QJkL+hz
	 ZG0/BW/sN78NLQa48z7JtWxh0NVTCIfLyqNZPzpvvPLSoqWyK2JeDhIFI69bT9lI0Z
	 63vfGLdEBxtPhCLdKF5lkBphtt8Bm5R0ypyVQ3OZPM0+/Xdc4GEFPRGZh8mwdHtY85
	 79vdEwMZZ7Bmk7TQCHrPlr+6m50mdPDwOqRv96x+7wG4AjagvvlTTMFCEM/zsBhpLb
	 3o6aTwCUSq3SA==
Subject: Re: [PATCH net 3/4] selftests: netfilter: check hardware offload work
 after DESTROY
From: netdev-bot+sashiko@kernel.org
To: florian.fainelli@broadcom.com
Cc: netdev@vger.kernel.org, pablo@netfilter.org, fw@strlen.de, phil@nwl.cc,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 horms@kernel.org, shuah@kernel.org, toshiaki.makita1@gmail.com,
 linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, linux-kselftest@vger.kernel.org
Date: Sun, 22 Nov 2026 21:17:27 +0000
Message-ID: <179538224794.3135.4220034619044485875@kernel.org>
In-Reply-To: <20261118201250.2075007-4-florian.fainelli@broadcom.com>
References: <20261118201250.2075007-4-florian.fainelli@broadcom.com>
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

Thank you for your contribution! Sashiko AI review found 7 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 3 · Low: 4

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The new test nft_flowtable_hw_destroy.sh uses the top-level
  tracefs instance, which the whole system shares, and draws conclusions…
- [Medium] nft_flowtable_hw_destroy.sh never deletes the four netdevsim
  devices it creates.
- [Medium] nft_flowtable_hw_destroy.sh reports SKIP instead of FAIL when
  no DESTROY work is seen, even though every prerequisite has already…
- [Low] nft_flowtable_hw_destroy.sh sets
  net.netfilter.nf_flowtable_tcp_timeout at line 105, before anything…
- [Low] In nft_flowtable_hw_destroy.sh, `tmpfile=$(mktemp)` runs at line
  19, but `trap cleanup EXIT` is only installed at line 40.
- [Low] nft_flowtable_hw_destroy.sh starts the socat TCP listener in ns2
  in the background (line 131) and then just does `sleep 1` (line 132)…
- [Low] selftests: netfilter: CONFIG_FTRACE=y alone does not enable
  CONFIG_TRACING

--

selftests: netfilter: check hardware offload work after DESTROY

This adds a netdevsim based selftest. It closes a TCP flow in a hardware
offload flowtable, then uses the workqueue_queue_work tracepoint to check
that no STATS or REPLACE offload work is queued after the DESTROY work. It
also adds CONFIG_FTRACE to the netfilter selftest config.

> diff --git a/tools/testing/selftests/net/netfilter/nft_flowtable_hw_destroy.sh b/tools/testing/selftests/net/netfilter/nft_flowtable_hw_destroy.sh
> new file mode 100755
> index 0000000000000..c0675378bd86f
> --- /dev/null
> +++ b/tools/testing/selftests/net/netfilter/nft_flowtable_hw_destroy.sh
> @@ -0,0 +1,162 @@
> +#!/bin/bash

[ ... ]

> +ret=0
> +tracing=/sys/kernel/tracing
> +trace_mounted=0
> +tmpfile=$(mktemp)
> +nsim_ids=""
> +
> +checktool "nft --version" "run test without nft tool"
> +checktool "socat -h" "run test without socat"

[Severity: Low]
Is the temporary file leaked when nft or socat is missing?

checktool() in netfilter/lib.sh runs exit $ksft_skip when the tool is
missing. The trap cleanup EXIT line is only installed further down, so the
rm -f "$tmpfile" in cleanup() never runs on that path.

Could the mktemp be moved after the trap is installed?

[ ... ]

> +nsim_new() {
> +	local id="$1" ns="$2" name
> +
> +	echo "$id 1" > /sys/bus/netdevsim/new_device || return 1
> +	nsim_ids="$nsim_ids $id"
> +	name=$(ls /sys/bus/netdevsim/devices/netdevsim"$id"/net)
> +	ip link set "$name" name "nsim$id" netns "$ns" || return 1
> +	echo "nsim$id"
> +}

[ ... ]

> +base=$((256 + RANDOM % 128 * 4))
> +a1=$(nsim_new "$base" "$ns1") || exit $ksft_skip
> +a2=$(nsim_new $((base + 1)) "$nsr1") || exit $ksft_skip
> +b1=$(nsim_new $((base + 2)) "$nsr1") || exit $ksft_skip
> +b2=$(nsim_new $((base + 3)) "$ns2") || exit $ksft_skip

[Severity: Medium]
Are the four netdevsim devices ever deleted?

nsim_new() appends to nsim_ids, but every call here is a command
substitution, and each one runs in a subshell. The update is lost and the
parent's nsim_ids stays empty. So this loop in cleanup():

	for id in $nsim_ids; do
		cleanup_netdevsim "$id"
	done

never writes anything to /sys/bus/netdevsim/del_device.

netdevsim's rtnl_link_ops has no netns_refund. When cleanup_all_ns deletes
the namespaces, default_device_exit_net() moves the netdevs back to
init_net, and the netdevsim$base..netdevsim$((base+3)) bus devices stay
registered. This happens on every run that gets past device creation,
whether it ends in PASS, FAIL or SKIP.

base can only take 128 values. A later run that picks the same base would
fail new_device and report SKIP.

Could nsim_ids be updated in the parent shell after each successful call
instead?

[ ... ]

> +# The statistics of a flow are polled once a tenth of its timeout went by, and
> +# the flow must stay around for longer than that after it is closed.
> +ip netns exec "$nsr1" sysctl -q net.netfilter.nf_flowtable_tcp_timeout=20
> +
> +if ! ip netns exec "$nsr1" nft -f - <<EOF

[Severity: Low]
Does this sysctl exist yet at this point?

nf_conntrack registers net.netfilter.nf_flowtable_tcp_timeout in
nf_ct_sysctl_table in nf_conntrack_standalone.c. The selftest config has
CONFIG_NF_CONNTRACK=m, and nothing before this line loads the module. The
first thing that loads it is the ct state rule in the nft -f ruleset below.

On a fresh boot, or when this test runs on its own, the write fails with
only a stderr message, and its exit status is ignored. The flow then keeps
the default 30 second timeout, not the 20 seconds the comment above relies
on. The current sleep values still give the right result, but the test is
not running with the timeout it configured.

Could the sysctl move after the ruleset is loaded, or could nf_conntrack be
loaded with modprobe first?

[ ... ]

> +ip netns exec "$ns2" socat -u TCP-LISTEN:12345,reuseaddr /dev/null &
> +sleep 1

[Severity: Low]
Is a fixed sleep 1 enough to be sure the listener is bound?

On a slow or loaded machine, the client below can connect before port 12345
is listening. The connection is then refused, no flow is added to the
flowtable, no DESTROY is queued, and the test exits with SKIP.

Other tests in this directory, such as nft_flowtable.sh, nft_nat.sh and
nft_queue.sh, use wait_local_port_listen or busywait for this. Could the
same be used here?

> +
> +echo 1 > "$tracing/events/workqueue/workqueue_queue_work/enable"
> +echo > "$tracing/trace"
> +
> +# Send data for the flow to be offloaded, then close the connection.
> +(for _ in 1 2 3 4 5 6; do echo data; sleep 0.3; done) | \
> +	ip netns exec "$ns1" socat -u - TCP:10.0.2.2:12345

[ ... ]

> +destroy=$(grep -n "workqueue=nf_ft_offload_del" "$tmpfile" | head -n 1 | cut -d: -f1)
> +if [ -z "$destroy" ]; then
> +	echo "SKIP: the hardware rule of the flow was not destroyed"
> +	exit $ksft_skip
> +fi

[Severity: Medium]
Should this be a FAIL rather than a SKIP?

By this point the test has already shown that the offload flowtable loaded
and that forwarding works through the netdevsim devices. If no
nf_ft_offload_del work shows up, there are two possible causes. Either the
TCP connection never happened, or the kernel path that should queue DESTROY
for the closed flow is broken:

net/netfilter/nf_flow_table_core.c:nf_flow_offload_gc_step() {
    ...
	} else if (test_bit(NF_FLOW_CLOSING, &flow->flags) &&
		   test_bit(NF_FLOW_HW, &flow->flags) &&
		   !test_bit(NF_FLOW_HW_DYING, &flow->flags)) {
		nf_flow_offload_del(flow_table, flow);
    ...
}

Reporting either case as a skip could hide a regression in the very path
this test covers.

The exit status of the socat client pipeline above is never checked
either, so a refused or failed connection goes unnoticed. Would it make
sense to check that too?

> +
> +late=$(tail -n +"$((destroy + 1))" "$tmpfile" | grep -c "workqueue=nf_ft_offload_\(stats\|add\)")

[Severity: Medium]
Can unrelated flowtables make this fail on a fixed kernel?

nf_ft_offload_add, nf_ft_offload_del and nf_ft_offload_stats are single
module-global workqueues created in nf_flow_table_offload_init().
flow_offload_queue_work() uses them for every flowtable in every netns.
The workqueue_queue_work output only carries the work struct, function and
workqueue name. Nothing in it identifies the flow or the netns.

If any other hardware offload flowtable is active during the run, its GC
STATS work lands after this flow's DESTROY and gets counted here. The
DESTROY line picked by head -n 1 above may also belong to a different
flow.

The test also uses the top-level tracefs instance, which the whole system
shares. The enable and the buffer clear before the client connects both
act on it. On top of that, cleanup() runs:

	if [ -d "$tracing/events/workqueue" ]; then
		echo 0 > "$tracing/events/workqueue/workqueue_queue_work/enable"
		echo > "$tracing/trace"
	fi

This always disables the event and wipes the global buffer, even on early
exits that never enabled it, and the previous enable state is never
restored. Wouldn't that throw away the trace data and event setup of any
other ftrace user?

Would a private instance under $tracing/instances/ work better, removed in
cleanup() and filtered on the workqueue name? Telling flows apart would
still need some per-flow way to identify the work.

[ ... ]

> diff --git a/tools/testing/selftests/net/netfilter/config b/tools/testing/selftests/net/netfilter/config
> --- a/tools/testing/selftests/net/netfilter/config
> +++ b/tools/testing/selftests/net/netfilter/config
> @@ -16,6 +16,7 @@ CONFIG_DUMMY=m
>  CONFIG_FAIL_FUNCTION=y
>  CONFIG_FAULT_INJECTION=y
>  CONFIG_FAULT_INJECTION_DEBUG_FS=y
> +CONFIG_FTRACE=y
>  CONFIG_FUNCTION_ERROR_INJECTION=y
>  CONFIG_INET_DIAG=m
>  CONFIG_INET_ESP=m

[Severity: Low]
Is CONFIG_FTRACE=y enough to get the workqueue_queue_work event?

In kernel/trace/Kconfig, FTRACE is the "Tracers" menuconfig. It only
opens the if FTRACE block and does not select anything by itself.
TRACING is the hidden symbol that pulls in EVENT_TRACING, TRACEPOINTS
and tracefs. Only a tracer selects it, either FUNCTION_TRACER and
friends through GENERIC_TRACER, or ENABLE_DEFAULT_TRACERS. Nothing
else in this config fragment selects it. FTRACE also already defaults
to y with DEBUG_KERNEL, so this line adds little on its own.

Suppose a kernel is built from this fragment on top of a base config
that has no tracer enabled. It then has no tracefs and no
events/workqueue directory. nft_flowtable_hw_destroy.sh takes the
"workqueue tracepoints are not available" exit and reports SKIP, so a
CI setup that relies on the fragment never actually runs the test.

Would adding CONFIG_ENABLE_DEFAULT_TRACERS=y here pull in TRACING the
way you need? The landlock selftest config does this. Or is there
another tracer option you would rather depend on?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261118201250.2075007-1-florian.fainelli%40broadcom.com
