Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26E71BAEF4
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Sep 2024 15:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726672135; cv=none; b=FESigxDMwLNIcDbH5LuPT8G2rB0N8uMS+Rw+hJVSHmzMTTqi1DHS7QG0UqNOFMBoLjz1XVw2ZZvCxzpHg4OrTEvDy3Vi14jwpf6ze0cRsevnJLYHOBj8Wx6Ib/EuIFImxEZYT9h7g3Gs7R5cirHn1WEMVvjMwnV7X05mMCdHXRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726672135; c=relaxed/simple;
	bh=XPA0QW0WvKYStiTcqAMiD428IqUOm+2119pbYbJyIdg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EwzHoz87/awpb9rFdxCn08HqLtTIhDOaPmqSnQtCVrvadTUSOIKDmGToRxVevjMz0NndWKryjd9Udq2crSzA5e4ML76DpQgen/6MnzHZwh63F/hCap2o5XO5isL2IBmkKJebOoB5Y3+nKSjFqaBDj3GSQyrfkIVdk3568+wUBOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=D930xsWI; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D930xsWI"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-42cae4eb026so67804055e9.0
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Sep 2024 08:08:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726672132; x=1727276932; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jA9lY/E0/QbpX16fUdqhJShbGAard86Mjjpn6imaB5E=;
        b=D930xsWIFwgQlkoBgvx0kn8C6uBavUaPr0jGJ3VrU1YIgpqoS2V3XE5whk2aiyn3xX
         0BSr0OHMW6D5EdCEF808y+lHhCGQuG5ofg7J7t6ued2GsAM8WBP9D8Of5+9IFKP2RbuC
         yb+tXDX+tvqy1yQk1FiZ6RocWxyX3yjvN3vWeybxKq+l6XoYXGT3Q6zNmENdw5b1zRg5
         TALvqdNTf/UDJFDAtwSH+AoZNieOR/RTp7Pp/1xLwoazaK18P0N53PL6Tx+fIdWP9Uk1
         ggw1u9F725KmUv1szv8JxQXMoM32NIbSVUECM6zbtg9UXP1AEOo3ktdH/QtWCcnii4At
         ZLBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726672132; x=1727276932;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jA9lY/E0/QbpX16fUdqhJShbGAard86Mjjpn6imaB5E=;
        b=S/RVAGgtUcOtE27ExIJeQx3siukLKOajZIeGUg+yNZe5RkqgD67S2LT+GYiP1ii3tH
         0e+6f+kuWKZSJDEjdOa/LPlBFsABigmOjaIREYR7nBfV/0sbH/hEzHe3zNAuSW7+jQVS
         OSmCbFWhhEYmzwWfmgVwns4XffUqPRBja5JsZ7QdShTcAy6GmLBpY0MhJwuSFaKOrAgl
         8ipx2kvjGFpQcNQYUX5NeMeLdbQ19ywkujTdMR4m85aTis/itau2L3DrF4oV9BJuhQ+6
         n7ubeexf2UPAKeFCgO3ozDZ//pAhrlmF+zw2xrj61iDnf7LYZCimBbzBxIVkNPRUQyX2
         wzag==
X-Gm-Message-State: AOJu0YwBoZA7zb3BkWVhqniY8oDt4N25QoJRmZ0wdZ0D6pNMZkJzF9ni
	6l28EiR129BvG1e/XUe7BXmso0CRDFncB+cL4I8f5jaeupgb9Ec4OZLDBU9WltWpBGDwp7Rur3K
	TaBWmJUuK+5uL4VDyv2JHphIjXNKqVL20fT2xQLvAHyxHhKobUF8u
X-Google-Smtp-Source: AGHT+IGuSYu/O2laPgDqRAh/GEfjTFPWGRFKEro/tnVfhQtNdkfBk6uY3l9avJDLeODHQvPgLbit938401JQJaxxmBI=
X-Received: by 2002:adf:efc9:0:b0:371:8a91:9e72 with SMTP id
 ffacd0b85a97d-378c2d119f7mr15028105f8f.30.1726672131482; Wed, 18 Sep 2024
 08:08:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240918131637.9733-1-fw@strlen.de>
In-Reply-To: <20240918131637.9733-1-fw@strlen.de>
From: Antonio Ojea <aojea@google.com>
Date: Wed, 18 Sep 2024 16:08:36 +0100
Message-ID: <CAAdXToTGaNiwNDViMpRxoz5=YZkH-bu6rtO5_6xmkvN7s1nW2w@mail.gmail.com>
Subject: Re: [PATCH nf] kselftest: add test for nfqueue induced conntrack race
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 18, 2024 at 2:38=E2=80=AFPM Florian Westphal <fw@strlen.de> wro=
te:
>
> From: Pablo Neira Ayuso <pablo@netfilter.org>
>
> The netfilter race happens when two packets with the same tuple are DNATe=
d
> and enqueued with nfqueue in the postrouting hook.
>
> Once one of the packet is reinjected it may be DNATed again to a differen=
t
> destination, but the conntrack entry remains the same and the return pack=
et
> was dropped.
>
> Based on earlier patch from Antonio Ojea.
>
> Link: https://bugzilla.netfilter.org/show_bug.cgi?id=3D1766
> Co-developed-by: Antonio Ojea <aojea@google.com>
> Signed-off-by: Antonio Ojea <aojea@google.com>
> Co-developed-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  .../selftests/net/netfilter/nft_queue.sh      | 92 ++++++++++++++++++-
>  1 file changed, 91 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/net/netfilter/nft_queue.sh b/tools/t=
esting/selftests/net/netfilter/nft_queue.sh
> index d66e3c4dfec6..a9d109fcc15c 100755
> --- a/tools/testing/selftests/net/netfilter/nft_queue.sh
> +++ b/tools/testing/selftests/net/netfilter/nft_queue.sh
> @@ -31,7 +31,7 @@ modprobe -q sctp
>
>  trap cleanup EXIT
>
> -setup_ns ns1 ns2 nsrouter
> +setup_ns ns1 ns2 ns3 nsrouter
>
>  TMPFILE0=3D$(mktemp)
>  TMPFILE1=3D$(mktemp)
> @@ -48,6 +48,7 @@ if ! ip link add veth0 netns "$nsrouter" type veth peer=
 name eth0 netns "$ns1" >
>      exit $ksft_skip
>  fi
>  ip link add veth1 netns "$nsrouter" type veth peer name eth0 netns "$ns2=
"
> +ip link add veth2 netns "$nsrouter" type veth peer name eth0 netns "$ns3=
"
>
>  ip -net "$nsrouter" link set veth0 up
>  ip -net "$nsrouter" addr add 10.0.1.1/24 dev veth0
> @@ -57,8 +58,13 @@ ip -net "$nsrouter" link set veth1 up
>  ip -net "$nsrouter" addr add 10.0.2.1/24 dev veth1
>  ip -net "$nsrouter" addr add dead:2::1/64 dev veth1 nodad
>
> +ip -net "$nsrouter" link set veth2 up
> +ip -net "$nsrouter" addr add 10.0.3.1/24 dev veth2
> +ip -net "$nsrouter" addr add dead:3::1/64 dev veth2 nodad
> +
>  ip -net "$ns1" link set eth0 up
>  ip -net "$ns2" link set eth0 up
> +ip -net "$ns3" link set eth0 up
>
>  ip -net "$ns1" addr add 10.0.1.99/24 dev eth0
>  ip -net "$ns1" addr add dead:1::99/64 dev eth0 nodad
> @@ -70,6 +76,11 @@ ip -net "$ns2" addr add dead:2::99/64 dev eth0 nodad
>  ip -net "$ns2" route add default via 10.0.2.1
>  ip -net "$ns2" route add default via dead:2::1
>
> +ip -net "$ns3" addr add 10.0.3.99/24 dev eth0
> +ip -net "$ns3" addr add dead:3::99/64 dev eth0 nodad
> +ip -net "$ns3" route add default via 10.0.3.1
> +ip -net "$ns3" route add default via dead:3::1
> +
>  load_ruleset() {
>         local name=3D$1
>         local prio=3D$2
> @@ -473,6 +484,83 @@ EOF
>         check_output_files "$TMPINPUT" "$TMPFILE1" "sctp output"
>  }
>
> +udp_listener_ready()
> +{
> +       ss -S -N "$1" -uln -o "sport =3D :12345" | grep -q 12345
> +}
> +
> +output_files_written()
> +{
> +       test -s "$1" && test -s "$2"
> +}
> +
> +test_udp_ct_race()
> +{
> +        ip netns exec "$nsrouter" nft -f /dev/stdin <<EOF
> +flush ruleset
> +table inet udpq {
> +       chain prerouting {
> +               type nat hook prerouting priority dstnat - 5; policy acce=
pt;
> +               ip daddr 10.6.6.6 udp dport 12345 counter dnat to numgen =
inc mod 2 map { 0 : 10.0.2.99, 1 : 10.0.3.99 }
> +       }
> +        chain postrouting {
> +               type filter hook postrouting priority srcnat - 5; policy =
accept;
> +               udp dport 12345 counter queue num 12
> +        }
> +}
> +EOF
> +       :> "$TMPFILE1"
> +       :> "$TMPFILE2"
> +
> +       timeout 10 ip netns exec "$ns2" socat UDP-LISTEN:12345,fork OPEN:=
"$TMPFILE1",trunc &
> +       local rpid1=3D$!
> +
> +       timeout 10 ip netns exec "$ns3" socat UDP-LISTEN:12345,fork OPEN:=
"$TMPFILE2",trunc &
> +       local rpid2=3D$!
> +
> +       ip netns exec "$nsrouter" ./nf_queue -q 12 -d 1000 &
> +       local nfqpid=3D$!
> +
> +       busywait "$BUSYWAIT_TIMEOUT" udp_listener_ready "$ns2"
> +       busywait "$BUSYWAIT_TIMEOUT" udp_listener_ready "$ns3"
> +       busywait "$BUSYWAIT_TIMEOUT" nf_queue_wait "$nsrouter" 12
> +
> +       # Send two packets, one should end up in ns1, other in ns2.
> +       # This is because nfqueue will delay packet for long enough so th=
at
> +       # second packet will not find existing conntrack entry.

for my own education,
will both packets use the same tuple and get a different dnat destination?
if both packets are enqueued for one second , -d option is
milliseconds, why the conntrack entry will not exist?


> +       echo "Packet 1" | ip netns exec "$ns1" socat STDIN UDP-DATAGRAM:1=
0.6.6.6:12345,bind=3D0.0.0.0:55221
> +       echo "Packet 2" | ip netns exec "$ns1" socat STDIN UDP-DATAGRAM:1=
0.6.6.6:12345,bind=3D0.0.0.0:55221
> +
> +       busywait 10000 output_files_written "$TMPFILE1" "$TMPFILE2"
> +
> +       kill "$nfqpid"
> +
> +       if ! ip netns exec "$nsrouter" bash -c 'conntrack -L -p udp --dpo=
rt 12345 2>/dev/null | wc -l | grep -q "^1"'; then
> +               echo "FAIL: Expected One udp conntrack entry"
> +               ip netns exec "$nsrouter" conntrack -L -p udp --dport 123=
45
> +               ret=3D1
> +       fi
> +
> +       if ! ip netns exec "$nsrouter" nft delete table inet udpq; then
> +               echo "FAIL: Could not delete udpq table"
> +               ret=3D1
> +               return
> +       fi
> +
> +       NUMLINES1=3D$(wc -l < "$TMPFILE1")
> +       NUMLINES2=3D$(wc -l < "$TMPFILE2")
> +
> +       if [ "$NUMLINES1" -ne 1 ] || [ "$NUMLINES2" -ne 1 ]; then
> +               ret=3D1
> +               echo "FAIL: uneven udp packet distribution: $NUMLINES1 $N=
UMLINES2"
> +               echo -n "$TMPFILE1: ";cat "$TMPFILE1"
> +               echo -n "$TMPFILE2: ";cat "$TMPFILE2"
> +               return
> +       fi
> +
> +       echo "PASS: both udp receivers got one packet each"
> +}
> +
>  test_queue_removal()
>  {
>         read tainted_then < /proc/sys/kernel/tainted
> @@ -512,6 +600,7 @@ EOF
>  ip netns exec "$nsrouter" sysctl net.ipv6.conf.all.forwarding=3D1 > /dev=
/null
>  ip netns exec "$nsrouter" sysctl net.ipv4.conf.veth0.forwarding=3D1 > /d=
ev/null
>  ip netns exec "$nsrouter" sysctl net.ipv4.conf.veth1.forwarding=3D1 > /d=
ev/null
> +ip netns exec "$nsrouter" sysctl net.ipv4.conf.veth2.forwarding=3D1 > /d=
ev/null
>
>  load_ruleset "filter" 0
>
> @@ -549,6 +638,7 @@ test_tcp_localhost_connectclose
>  test_tcp_localhost_requeue
>  test_sctp_forward
>  test_sctp_output
> +test_udp_ct_race
>
>  # should be last, adds vrf device in ns1 and changes routes
>  test_icmp_vrf
> --
> 2.44.2
>
