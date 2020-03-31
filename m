Return-Path: <SRS0=TvDw=5Q=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FB75C43331
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 Mar 2020 17:35:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4217720BED
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 Mar 2020 17:35:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="myHfzntm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbgCaRft (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 31 Mar 2020 13:35:49 -0400
Received: from mail-vs1-f47.google.com ([209.85.217.47]:43131 "EHLO
        mail-vs1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbgCaRft (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 31 Mar 2020 13:35:49 -0400
Received: by mail-vs1-f47.google.com with SMTP id w185so14006534vsw.10;
        Tue, 31 Mar 2020 10:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=fxtt1kpuj3bvbtg/PKwO9hDKPL/WW4xKfq8dYPHQcaQ=;
        b=myHfzntm10oNH7OpG1H3wpjLpRY0MiSS6qn3Po2OIjxxSu+JNj1UA/Hl0SJrWfvfAO
         Hsd1YuQCY5TYN+ZoUEluFH31vXXkDMbdA+KxWC5px8+L2my3QJ/8EPRzgguvFpQ83J/Q
         pbA+m6jlgxHQoHrkFFVM+9k8z22xyMv8cT1oZi7mP2R3RdPv+Fx8m3evwlf8TFzlbjxl
         VXe9ZS6Dg6rzwa6Ko6SwHx2gCMfiLSLe7kIKWTlpjcz7uY2MMfR3nAJWkpdJO/CTyR0d
         +CmSOggWLyMqQgnqpOP5AUZNTr/yxcIjMuq7ise3yTHgdKPdO5pdcOMO2Di44xu50AvF
         O/KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=fxtt1kpuj3bvbtg/PKwO9hDKPL/WW4xKfq8dYPHQcaQ=;
        b=odESLniCCM7EQU92ATQvqiNvSMWVJiC0HWJjwVYUNmtIVkf8X0yI4oFWDfZYStP0dc
         DZFh7tH49Fwy14GAaOJnQHxN5q8KrhJVw3SjMRiUCr0ncBcaI331t+lzh4ym/Q+twfbC
         i2vgPoR0vnyhrf+CG+uGVR164rVoVW1kaX8bPBxLQGGDLrz8UIAKMeYdYthDeNQeAeq3
         SmHxQdrCXKbJNmnYOhbk8yFSW39o+n0Z271WI8PsjVuowp+ek+Y3fLEsm2TEttqxNlWv
         llpyfzgKegdI+t5p81SDfpRQ5CYGW2bwT4K7K3K+H8yJjYphaxZZw1IYyBPq6kPDh7hE
         Mn8A==
X-Gm-Message-State: AGi0PuZJaCHqjMcmj08Q32l0oF8jcJs4ll0G/oBy2AbOwjPJprDw0dnW
        X8X+nnlfFPNy475iG2VZtDtZKHVJ0ZW/IpXHWMbdk9McdO8=
X-Google-Smtp-Source: APiQypJcFV6OcfcNvXJgegk+gZbawI3+FWCNtKkU4nPxmNwHYwZGLtJM4fLPX5/GYqjCILkMR+h4fu6lUsEPaJjctRE=
X-Received: by 2002:a67:2ed2:: with SMTP id u201mr13705421vsu.209.1585676146725;
 Tue, 31 Mar 2020 10:35:46 -0700 (PDT)
MIME-Version: 1.0
From:   Laura Garcia <nevola@gmail.com>
Date:   Tue, 31 Mar 2020 19:35:35 +0200
Message-ID: <CAF90-WgSo3SbBR4zsXH99380r5rSpZRGrpbKbh3oSRa9Qr8C6w@mail.gmail.com>
Subject: [ANNOUNCE] nftlb 0.6 release
To:     Mail List - Netfilter <netfilter@vger.kernel.org>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi!

I'm honored to present

    nftlb 0.6

nftlb stands for nftables load balancer, a user-space tool
that builds a complete load balancer and traffic distributor
using the nft infrastructure.

nftlb is a nftables rules manager that creates virtual services
for load balancing at layer 2, layer 3 and layer 4, minimizing
the number of rules and using structures to match efficiently the
packets. It comes with an easy JSON API service to control,
to monitor and automate the configuration.

Most important changes in this version are:

* Support of static and dynamic sessions for all LB modes (NAT-based
and ingress-based) with a configurable structure based on IPs, ports
or MAC addresses.
* Full session management via API.
* Improvement of API error message responses.
* Optimization of security policy lists and ipv6 support.
* Option to send commands to nft in batches or serialized.
* Support of local services, in cases where security policies managed
by nftlb are required for non-forwarded services.
* Support of dual-stack discovery for DSR and stateless-dNAT.
* Support of several output interfaces for DSR and stateless-dNAT.
* Support of connection tracking offload.

For further details, please refer to the official repository:

https://github.com/zevenet/nftlb

You can download this tool from:

https://github.com/zevenet/nftlb/releases/tag/v0.6

Special thanks to the issue reporters kerframil and zhanrox.

Happy load balancing!

--
Detailed changelog:

=E2=80=93 farms: disable static sessions deletion after farm down
=E2=80=93 sessions: delete static sessions when modifying the persistence s=
tructure
=E2=80=93 farms: fix farm limit objects reload
=E2=80=93 backends: fix start backend low priority with stateful object
=E2=80=93 nft: fix delete filter elements when its not needed
=E2=80=93 server: fix sigfault during a bad request
=E2=80=93 server: return not found during a get farm that doesn=E2=80=99t e=
xist
=E2=80=93 policies: revert farms used counter in json dump
=E2=80=93 sessions: fix backend marks used in session persistence
=E2=80=93 sessions: support of deletion of timed sessions via API
=E2=80=93 tests: add pre and post script for every test case
=E2=80=93 farms: fix reload of tcpstrict and nfqueue
=E2=80=93 server: unify api error messages and add verbose of the error
=E2=80=93 server: fix sigsegv after requesting non existent URI key
=E2=80=93 farms: fix helper rules generation
=E2=80=93 nft: fix forward map reload based on backends
=E2=80=93 src: apply pre and pos actionable when the attribute has changed
=E2=80=93 nft: use backend marks in forward chain
=E2=80=93 backends: reload farm in case of updating priority of a down back=
end
=E2=80=93 backends: delete unused farm pointer in backends set priority
=E2=80=93 backends: recalculate backends available when changing the backen=
d priority
=E2=80=93 src: remove unneeded debug messages
=E2=80=93 policies: disable printing of automatic parameters and avoid the =
priority -1
=E2=80=93 backends: fix backend action when is not available
=E2=80=93 tests: improve api testing system and remove obsolete DESC parame=
ter
=E2=80=93 config: avoid to print unknown key as null
=E2=80=93 nft: optimize static sessions rules to avoid to enter to dynamic =
map
=E2=80=93 farms: do not return error when the farm doesn=E2=80=99t need to =
be rulerized
=E2=80=93 server: fix sigsegv when returned rules generation error
=E2=80=93 config: improve parsing error messages
=E2=80=93 main: simplify previous nftlb tables check
=E2=80=93 main: detect and clean any previous nftlb tables
=E2=80=93 nft: avoid to flush the whole nft ruleset when deleting all farms
=E2=80=93 config: improve api response messages
=E2=80=93 nft: fix dynamic persistence rules
=E2=80=93 farms: fix stateless dnat source MAC in order to ensure a consist=
ent traffic
=E2=80=93 server: modify source code to fully support ipv6
=E2=80=93 sessions: introduce static and dynamic sessions support for DSR a=
nd
stateless DNAT
=E2=80=93 backends: use farm source address when available
=E2=80=93 farms: disable network discovery when configured loopback network=
 devices
=E2=80=93 tests: rename api tests directories to a human-readable format
=E2=80=93 tests: fix tests in order to force a given ether address
=E2=80=93 backends: fix =E2=80=9Cforce up status when configuring config_er=
ror=E2=80=9D
=E2=80=93 network: fix ether address discovery for ipv4 and ipv6
=E2=80=93 farms: fix log level for some debug messages
=E2=80=93 backends: force up status when configuring config_error
=E2=80=93 policies: add support of _family_ attribute to introduce ipv6 pol=
icies
=E2=80=93 backends: ensure to validate backends during map generation
=E2=80=93 elements: start element when created
=E2=80=93 farms: avoid configuring a config_err state
=E2=80=93 farms: avoid to set priority 0
=E2=80=93 policies: do not store elements
=E2=80=93 nft: fix dynamic persistence rules
=E2=80=93 network: introduce support of dual-stack in the networking layer
=E2=80=93 nft: fix generation of ipv6 filter chain
=E2=80=93 nft: add option to serialize nft commands
=E2=80=93 nft: fix flow offload testing cases
=E2=80=93 nft: refactorize farm log-prefix rules
=E2=80=93 tests: fix flowoffload test output
=E2=80=93 farms: introduce support of flow offload
=E2=80=93 backends: delete unused parameter in backend switch
=E2=80=93 nft: avoid to log per virtual service twice
=E2=80=93 sessions: delete debug messages
=E2=80=93 sessions: add static and dynamic session support
=E2=80=93 farms: add support for local services
=E2=80=93 nft: refactor chain base generation to add forward chain support
=E2=80=93 tests: fix test files
=E2=80=93 nft: simplify the chain and services name generation
=E2=80=93 farms: enable several outbound interfaces for stateless dnat
=E2=80=93 farms: fix won=E2=80=99t rulerize for stateless dnat without back=
ends
=E2=80=93 farms: support of stateless dnat direct clients
=E2=80=93 farms: fix masquerade bit with masquerade
=E2=80=93 farms: remove double generation of network interface index
=E2=80=93 backends: use backend output interface whenever is possible
=E2=80=93 backend: support of output interface per backend
=E2=80=93 readme: delete low level networking input parameters
=E2=80=93 backends: fix output interface calling when setting a new ip addr=
ess
=E2=80=93 farms: fix segfault when configuring stateless dnat
=E2=80=93 backends: force to one element if the backend is uniquely identif=
ied
=E2=80=93 nft: fix source address mapping in farm single port
=E2=80=93 elements: fix flushing elements in policies
=E2=80=93 farms: fix source address mapping with multiport virtual services
=E2=80=93 nft: avoid sprintf over the same buffer
=E2=80=93 farms: fix stopping farm while deleting service
=E2=80=93 tests: allow to stop in an api call
=E2=80=93 backends: fix backend status while removing all farms
=E2=80=93 backends: enable mixed source natting per backend
=E2=80=93 tests: refactor the test system for better maintenance
=E2=80=93 policies: create sets with auto-merge by default
=E2=80=93 policies: load elements if policy is not empty
=E2=80=93 policies: optimize rulerization of policies
=E2=80=93 nft: avoid zero marks
=E2=80=93 backends: fix backend with mark 0x0
=E2=80=93 backends: fix reload backends with source address
=E2=80=93 farms: fix error parsing object in level -1 with limits
=E2=80=93 server: add client request log info
=E2=80=93 main: retrieve and print segfault signals
=E2=80=93 tests: add api test to change the port per backend
=E2=80=93 tests: enhance the api testing by not removing the reports files
when it=E2=80=99s unknown
=E2=80=93 backends: enable masquerade and configurable source address per b=
ackend
=E2=80=93 farms: fix object rulerization
=E2=80=93 policies: fix rules creation and deletion of policies
=E2=80=93 tests: add api tests for policies
=E2=80=93 farms: fix rulerize everything stops after wont rulerize
=E2=80=93 farms: add api test case for deleting farms
=E2=80=93 backends: fix priority generation after node deletion
=E2=80=93 tests: create more api tests
=E2=80=93 farms: make farms rulerize loop safe
=E2=80=93 backends: fix priority generation
=E2=80=93 main: implement daemon mode
=E2=80=93 tests: classify the api testing system
=E2=80=93 nft: fix filter table regeneration after farms flush
=E2=80=93 tests: new api specific testing system
=E2=80=93 server: fix rules deletion when deleting a backend
=E2=80=93 backends: fix free of default macro defined log prefix
=E2=80=93 nft: fix mark print output in backends map
=E2=80=93 src: add support of log prefix
=E2=80=93 tests: fix test nft output with the latest changes
=E2=80=93 backends: add support of source address per backend
=E2=80=93 readme: update rst rtlimit burst option
