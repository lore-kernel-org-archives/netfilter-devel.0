Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC5D42D9ECD
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Apr 2026 15:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777562594; cv=none; b=cw1vMSVqbCeXLFHtwZs626Rg5mhlqKIFF67rRmRx7fJqUoLEy0VAW+gXzp47Fu4adGBTK548IP6YgTNheKVI/c4CTyoZdX0CneRlwIWPXBIw8Hj/xytxPzoPtzzvME1a1xgckCChZr4K8WvVIUwtnKlTpqeyhjzl8zyhHCkuQjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777562594; c=relaxed/simple;
	bh=RBbfO11SnIa8pXUTjS6/Ors4lymT9n12PqlbVnaClHo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l1rSiXi3k3CvNddU+mK05flW9MKyYUPIhzzMuXcPTFqdS46wwIaNYxPAamAmxp/nQOEPQOlf+JG17Rx+wS7lu8rtx2miVP/PwHfysSzqe4OTDKZZXQpC4PqpctxGqikNMSwvJbD5b7HNjS/+N4Zlg6fEc4iDQ+JNgCnDqupeZ28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Ehr7Yos2; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Ehr7Yos2"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id AB68B60179;
	Thu, 30 Apr 2026 17:23:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1777562590;
	bh=SovKV3wVm8c3m6zU6UFfEA1OG6dVYWE0/4uAMFfranM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ehr7Yos2wNRhsBnlzmjLKKDY83ICSVEmAKYP4NMf6cWsGQUSrHjBM4723SEsVXl5/
	 roaMaUz6Z8zvqDKcQ9290US04/hDgmNU2MXosOGshSspgvMhbVooPY02EUZDjF+xmc
	 zjm77lOg/Kp90ZQV8h8i3hLJ9s/+MEgEA2hEbl/9p8OUqOdW/cvHWIyGC6R/Yg//4A
	 amKq7Dy2a/Po80hd3d7T4v+7Jz1tFIMlmspSwAD7J/G6MCw0X6hGxb3pRmOPb27LkA
	 Y91q4k7HiHDbX1me4j1pB3QXYpyqr4aUaZDsXv5iuSiR0JdqXUi/FS9tqUEXaEp611
	 fbwnmBzpnQTBg==
Date: Thu, 30 Apr 2026 17:23:08 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: rc <rc@rexion.ai>
Cc: fw@strlen.de, security@kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: netfilter: nf_conntrack_irc: port truncation via simple_strtoul
 to u16 enables NAT pinhole
Message-ID: <afNz3OrUVkshakQU@chamomile>
References: <PXMDJKI85TU4.1D0TDUURTP402@mailcore-6d9c45d7fd-m8dqv>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <PXMDJKI85TU4.1D0TDUURTP402@mailcore-6d9c45d7fd-m8dqv>

Cc'ing netfilter-devel@

On Thu, Apr 30, 2026 at 03:00:20PM +0000, rc wrote:
> hey,
>  
> I would like to report the above security issue:
>  
>  
>  Affected versions: all kernels with net/netfilter/nf_conntrack_irc.c 
> (verified present in 7.1.0-rc1 mainline, code unchanged since initial
> implementation)
>  
>  
> Description
> -----------
>  
>  
> parse_dcc() in nf_conntrack_irc.c stores the return value of
> simple_strtoul() directly into a u_int16_t pointer (line 96):
>  
>  
>  *port = simple_strtoul(data, &data, 10);
>  
>  
> simple_strtoul() returns unsigned long. When the attacker-controlled
> port string in a DCC command exceeds 65535, the value silently
> truncates to u16. For example:
>  
>  
>  65558 → u16 = 22 (SSH)
>  131094 → u16 = 22 (SSH)
>  65536 → u16 = 0
>
> An attacker on an IRC channel can send a crafted DCC SEND message
> through a Linux NAT gateway running the nf_conntrack_irc helper. The
> helper parses the port, truncates it, and opens a NAT pinhole
> (via nf_nat_irc) for the truncated port on the internal host. This
> bypasses the firewall/NAT to expose arbitrary services (SSH, HTTP,
> database ports) on internal hosts.

You don't need truncation to open a port via conntrack helper with an
expectation.

Tighening the conntrack helper parser is fine, this is net-next
material:

0) There is a document by Eric Leblond already explaining the
   situation with conntrack helpers, which is old.
1) Helper are disabled by default, you have to enable them explicitly
   via ruleset, for some time already.

Thanks for your report.

> The only existing check after the parse (line 216 in help()) rejects
> port 0:
>  
>  
>  if (... dcc_port == 0) {
>  net_warn_ratelimited("Forged DCC command...");
>  continue;
>  }
>  
>  
> Port 0 is rejected but any non-zero truncated value passes.
> 65558 % 65536 = 22, which is non-zero and opens a pinhole to SSH.
>  
>  
> The nf_conntrack_amanda helper at nf_conntrack_amanda.c:135 has
> the same pattern but with a partial mitigation: it checks len > 5
> (rejecting strings longer than 5 digits, capping the parseable
> value at 99999). Values 65536-99999 still truncate — the same fix
> (explicit > 65535 check) is needed there. The nf_conntrack_sip


> helper has a correct range check. The nf_conntrack_ftp helper uses
> a custom parser (try_number / get_port), not simple_strtoul.
>  
>  
> Trigger path
> ------------
>  
>  
>  Attacker sends IRC message:
>  PRIVMSG victim :DCC SEND file 1234567890 65558
>  
>  
>  Internal victim's IRC client processes the DCC
>  |
>  Packet traverses Linux NAT gateway
>  |
>  nf_conntrack_irc help() nf_conntrack_irc.c:102
>  parse_dcc() line 204
>  simple_strtoul("65558") returns 65558 (unsigned long)
>  *port = 65558 truncated to u16 = 22
>  dcc_port = 22 passes dcc_port != 0 check
>  |
>  nf_nat_irc opens NAT pinhole for port 22
>  |
>  External attacker connects to victim_ip:22 through the pinhole
>  
>  
> Reproducer
> ----------
>  
>  
> This is a logic bug, not a memory safety issue. No KASAN trigger or
> crash. The attached verify_truncation.c demonstrates the exact
> truncation using the same C type semantics the kernel uses
> (unsigned long → unsigned short assignment). Compiled and run on the
> host (6.19.14-zen1-1-zen, x86_64):
>  
>  
>  $ gcc -o verify_truncation verify_truncation.c && ./verify_truncation
>  65558 → 22 SSH
>  131094 → 22 SSH
>  65536 → 0 REJECTED (port 0 check)
>  
>  
> To test on a live NAT gateway:
> 1. Load nf_conntrack_irc: modprobe nf_conntrack_irc
> 2. Set up NAT with iptables
> 3. Send IRC DCC message with port 65558 through the gateway
> 4. Observe conntrack expectation for port 22:
>  conntrack -E expect
>  
>  
> Impact
> ------
>  
>  
> NAT/firewall bypass. An attacker can open pinholes to arbitrary
> TCP ports on internal hosts behind a Linux NAT gateway running the
> nf_conntrack_irc helper module. The attacker needs to be on the same
> IRC channel as an internal user and can target any port by choosing
> the appropriate value (target_port + N*65536).
>  
>  
> The nf_conntrack_irc module is loaded automatically by connection
> tracking when IRC traffic is detected on configured ports (default:
> port 6667). Any NAT box with connection tracking and default module
> autoloading is potentially exposed — the gateway does not need to be
> intentionally running an IRC service.
>  
>  
> Conditions
> ----------
>  
>  
> - nf_conntrack_irc module loaded (auto-loaded when IRC traffic hits
>  configured ports, even if the gateway itself is not an IRC server)
> - Linux system acting as NAT gateway
> - IRC traffic passing through the gateway
> - CONFIG_NF_CONNTRACK_IRC enabled (common on gateway/firewall distros)
>  
>  
> Proposed fix
> ------------
>  
>  
> --- a/net/netfilter/nf_conntrack_irc.c
> +++ b/net/netfilter/nf_conntrack_irc.c
> @@ -93,7 +93,11 @@ parse_dcc(...)
>             data++;
>       }
>  
>  
> -     *port = simple_strtoul(data, &data, 10);
> +     {
> +           unsigned long parsed_port = simple_strtoul(data, &data, 10);
> +           if (parsed_port == 0 || parsed_port > 65535)
> +                 return -1;
> +           *port = parsed_port;
> +     }
>       *ad_end_p = data;
>  
>  
> The caller at line 204 already handles parse_dcc returning non-zero
> by printing a debug message and continuing to the next match:
>  
>  
>  if (parse_dcc(...)) {
>  pr_debug("unable to parse dcc command
> ");
>  continue;
>  }
>  
>  
> So the -1 return correctly prevents the NAT expectation from being
> created. The existing port-0 check at line 216 in help() becomes
> unreachable for port 0 since parse_dcc now rejects it first — this
> is harmless dead code that can optionally be removed for clarity.
>  
>  
> The same fix should be applied to nf_conntrack_amanda.c:135, where
> the len > 5 partial mitigation still allows truncation for values
> 65536-99999.
>  
>  
> Disclosure
> ----------
>  
>  
> This has not been shared publicly or with any third party.
>  
>  
> Attachments
> -----------
>  
>  
>  verify_truncation.c runtime truncation verification program
>  
>  
> Regards,
> Rahul

> #include <stdio.h>
> #include <stdlib.h>
> 
> /* Replicate the kernel's simple_strtoul -> u16 assignment */
> int main(void) {
>     /* These are the values an attacker would put in a DCC SEND message */
>     unsigned long test_ports[] = { 22, 80, 443, 65535, 65536, 65558, 131094, 196630, 0 };
>     int i;
> 
>     printf("=== nf_conntrack_irc port truncation verification ===\n\n");
>     printf("%-15s ??? %-10s  %s\n", "DCC port", "u16 result", "Maps to");
>     printf("%-15s   %-10s  %s\n", "----------", "----------", "-------");
> 
>     for (i = 0; test_ports[i] || i == 0; i++) {
>         unsigned long parsed = test_ports[i];
>         unsigned short truncated = (unsigned short)parsed;  /* same as kernel u_int16_t assignment */
>         printf("%-15lu ??? %-10u", parsed, truncated);
>         if (truncated == 22) printf("  SSH");
>         else if (truncated == 80) printf("  HTTP");
>         else if (truncated == 443) printf("  HTTPS");
>         else if (truncated == 0) printf("  REJECTED (port 0 check)");
>         else if (truncated == 3306) printf("  MySQL");
>         else if (truncated == 5432) printf("  PostgreSQL");
>         printf("\n");
>         if (test_ports[i] == 0) break;
>     }
> 
>     printf("\n=== Targeted NAT pinhole examples ===\n\n");
>     unsigned short targets[] = { 22, 80, 443, 3306, 5432, 8080, 3389 };
>     const char *names[] = { "SSH", "HTTP", "HTTPS", "MySQL", "PostgreSQL", "HTTP-alt", "RDP" };
>     for (i = 0; i < 7; i++) {
>         printf("To open port %5u (%-10s): send DCC port %u\n",
>                targets[i], names[i], (unsigned int)targets[i] + 65536);
>     }
> 
>     printf("\n=== Verification: kernel code path ===\n");
>     printf("nf_conntrack_irc.c:96:\n");
>     printf("  *port = simple_strtoul(data, &data, 10);\n");
>     printf("  // port is u_int16_t*, simple_strtoul returns unsigned long\n");
>     printf("  // values > 65535 silently truncate\n");
> 
>     return 0;
> }

