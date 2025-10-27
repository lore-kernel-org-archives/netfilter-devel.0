Received: from serval.cherry.relay.mailchannels.net (serval.cherry.relay.mailchannels.net [23.83.223.163])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2184926ACB
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Oct 2025 03:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.223.163
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761536181; cv=pass; b=a3Kt/tDTmO7HgtoPG34DfLq9/leNuuuNUbMIB4AqZX617yUPxasx0RDZlMWWzWhhAHjiAT8PfEeaB0ZiFDBwTtmO3EjsdCsjZxLhkVCJau+aV9KUGX0zVMwRVaJwhjcQhaN7Js8CFjKAUSbCOj8L49ESlZRGM8Dh+2d/OwoELeA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761536181; c=relaxed/simple;
	bh=/NQfkhMySEOr51Fv6CCsmhgswt5Zv9/zeMHZbkk19SQ=;
	h=Message-ID:Subject:From:To:Date:Content-Type:MIME-Version; b=e2iRkkGn/WmsmqcwzaSrgWH6xSq3egVtFANzKRisYw3a27E1JduyUD4ZVmTrOkg42t6GRKOqY4GOft3r1+5kNNAph7StRjmlkW6CRp9jBB9t/NoJomAxTyMPzhlC7CUs7g0T7U7DcOvnYy1CsoZriHzaXpJb9e5AprLgO8Sv6r8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=scientia.org; spf=pass smtp.mailfrom=scientia.org; arc=pass smtp.client-ip=23.83.223.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=scientia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 8C9FE406AC
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Oct 2025 03:36:12 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (trex-green-8.trex.outbound.svc.cluster.local [100.123.122.56])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id EE2D940A4D
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Oct 2025 03:36:11 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1761536172; a=rsa-sha256;
	cv=none;
	b=eX2QR6kCIP507sxUStZNIaYz5j6hbebBc+LiFN+sxzy3HHT9RWjNuGE7iIZ9QJviKLF287
	vxud05j+sohIkjquR23GNNi1zBvBKgLtkfcWZiO2vuM9trFwegvKrOXFMZkj6E4JsplTGc
	IiFkuMjAWERdWL+f6odBOUvxmQLQAF6Ww3JZHckZCDg1RmRfHmhuTS9sKyUO3PHfZlwoTq
	QOhFhvgmaVpxTAMIFRIX0NvYNE+9vxmbWgWLkgpsW7v0OTSlBzAMK5GZN8oP/c6wFLoByK
	pd1MTt4/dTjTokzh56IUKR/gchCWoginTfvcajdPrUp1ZrtPK/GCaf3U1JaJkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1761536172;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=xPCHERzr4JGx2nUe8Y5sDjS94ra5EbJNLoH9dSrSUp4=;
	b=JZkTPxf0ucMeYI06ADNNhCV4bwsTIfkTnXA9Vnrz+eG+6hUK3RilBl+66v2534DheKzoxU
	t3u+9rNqPNQGyLSLqfxaunT7nOtsWRAJX7IhHfiI/yV2NLB6BBubKSM3d3Ewai7Or5G4DO
	78KN0S39kKxJfS41NGWPtowlKCHY126Ybb2856Sgfkg2I8kWDpXjfSSz7BGCu0+L80eQ8f
	IExRYYkLchd4ENiB7NWq/rRscoTJhdspPZB0LIppbmE3xcXEVFYJgrbB0RD9j1ZOjLM2BV
	iPMVT4WuEidGZZU+xqeTQtV80ZZzB6p+boSzAM5xd/eREm5xO1I/L4P+X3czTQ==
ARC-Authentication-Results: i=1;
	rspamd-674f557ffc-6dxcj;
	auth=pass smtp.auth=instrampxe0y3a smtp.mailfrom=calestyo@scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Neutral
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Stretch-Drop: 1d0328ca15474d5b_1761536172521_891881093
X-MC-Loop-Signature: 1761536172521:1554066267
X-MC-Ingress-Time: 1761536172520
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.123.122.56 (trex/7.1.3);
	Mon, 27 Oct 2025 03:36:12 +0000
Received: from [212.104.214.84] (port=24263 helo=[10.2.0.2])
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <calestyo@scientia.org>)
	id 1vDE1h-00000000Cpy-3k8m
	for netfilter-devel@vger.kernel.org;
	Mon, 27 Oct 2025 03:36:10 +0000
Message-ID: <71e8f96ac2cd1ee0ab8676facb04b40870a095a1.camel@scientia.org>
Subject: nftables.service hardening ideas
From: Christoph Anton Mitterer <calestyo@scientia.org>
To: netfilter-devel@vger.kernel.org
Date: Mon, 27 Oct 2025 04:36:08 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-5 
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-AuthUser: calestyo@scientia.org

Hey.


This would be ideas about further hardening nftables.service, primarily
using the options from systemd.exec(5).


1. The current .service already has:
> ProtectSystem=3Dfull

This can be further tightened to:
> ProtectSystem=3Dstrict

which not only mounts some but the entire fs hierarchy read-only for
the service's commands.
I guess nft -f should never write anywhere, or does it? At least it
seems to work.

Setting ProtectSystem=3D effectively does something like PrivateMounts=3D,
so that is recommended not to be set.


2. As per ProtectSystem=3D=E2=80=99s documentation, which refers to
ReadOnlyPaths=3D=E2=80=99s:
- I assume nft never mounts anything (that wouldn't be propagated back
  to the main namespace.
- ReadOnlyPaths=3D docs say, either
    CapabilityBoundingSet=3D~CAP_SYS_ADMIN=C2=A0
  and/or
    SystemCallFilter=3D~@mount
  shall be set, or a process can undo any ReadOnlyPaths=3D (and thus also
  ProtectSystem=3D and others.

SystemCallFilter=3D docs extend this to if any of PrivateTmp=3D,
PrivateDevices=3D, ProtectSystem=3D, ProtectHome=3D, ProtectKernelTunables=
=3D,
ProtectControlGroups=3D, ProtectKernelLogs=3D, ProtectClock=3D,
ReadOnlyPaths=3D, InaccessiblePaths=3D and ReadWritePaths=3D
are used.

We might actually set both:
> CapabilityBoundingSet=3D~CAP_SYS_ADMIN=20
> SystemCallFilter=3D~@mount

(for CapabilityBoundingSet=3D even more, see below).


3. Using SystemCallFilter=3D in turn is recommended to use: >
SystemCallArchitectures=3Dnative

I'd guess nft doesn't use syscals from other archs?!


4. I guess nft needs no capabilities/privileges other than
CAP_NET_ADMIN:
> CapabilityBoundingSet=3DCAP_NET_ADMIN
> AmbientCapabilities=3D""
> NoNewPrivileges=3Dyes

CapabilityBoundingSet=3DCAP_NET_ADMIN would supersede the =3D~CAP_SYS_ADMIN
from (2) above.

AmbientCapabilities=3D"" disables all ambient capabilities, I'd blindly
guess that nftables doesn't execve(),... but it shouldn't harm either.


5. There should be no reason why nft -f needs to access stuff in /tmp
or /var/tmp of anything else, so:
> PrivateTmp=3Dyes

this makes however /tmp/ and /var/tmp/ will be writable again (despite
the ProtectSystem=3Dstrict).

Even safer would be:
> PrivateTmp=3Disolate

but than we also need (because we have DefaultDependencies=3Dno and some
other conditions fulfilled):
> RequiresMountsFor=3D/var

or /var/tmp could "leak out".


6. I'd guess nft -f never changes the clocks or directly reads/writes
to the kernel log buffer (or does it):
> ProtectClock=3Dyes
> ProtectKernelLogs=3Dyes

This also blocks syslog(2) (but not syslog(3)).


7. AFAICS, nft -f may cause modules to be loaded, but that's done
indirectly (i.e. I guess by the kernel itself?), so we can
> ProtectKernelModules=3Dyes

Also makes /usr/lib/modules inaccessible, should that be used somehow.


8. I guess nft -f doesn't use devices (other than some standard ones
like /dev/null, etc.), IPC, RT nor namespaces and doesn't set
SUID/SGID:
> PrivateDevices=3Dyes
> PrivateIPC=3Dyes
> RestrictNamespaces=3Dyes
> RestrictRealtime=3Dyes
> RestrictSUIDSGID=3Dyes


9. Does nftables use BPF or personalities? If not:
> PrivateBPF=3Dyes
> LockPersonality=3Dyes


10. A bit obscure perhaps...
> OOMScoreAdjust=3D-1000
or:
> OOMScoreAdjust=3D-999

The idea would be that nftables.service is security critical and should
rather not be OOMkilled in memory tight situations, also since it's
oneshot it would anyway give resources back soon.

Along with that one might set:
> OOMPolicy=3Dkill

the default action is variable and set in system.conf (where it
defaults to stop).
Better a safe kill then sorry?!


Except perhaps for 10, the above things are IMO not totally
unreasonable.
So leats get a bit more exotic ;-)


11. Restrict executable paths:
> NoExecPaths=3D/
> ExecPaths=3D/usr/sbin/nft -/lib -/usr/lib

Not sure whether we'd also need to add locations lib32, lib64, libc32.
The above at least works on my amd64 Debian.


12. May unneeded pathnames inaccessible:
> InaccessiblePaths=3D-/boot -/media -/mnt -/opt -/proc -/srv -/sys -/var
> TemporaryFileSystem=3D/etc:ro
> BindReadOnlyPaths=3D/etc/protocols /etc/services /etc/passwd /etc/group /=
etc/nftables /etc/nftables.conf /etc/resolv.conf

- Some of these are already readonly, but why allowing even that if not
  neeed?!
- /dev, /home, /root and /tmp are already secured via other options
- I consider /bin/, /lib*, /sbin, /usr to never contain anything
  sensitive.
  But perhaps /usr/local could be blocked (might contain private code).
- /proc/ and /sys are seemingly not needed.
- /run is apparently needed, so cannot be blocked
- /etc/ is needed, but not all of it, so I make a tmpfs mount on it,
  and bindmount only the needed stuff.
  - The above uses the Debian config /etc/nftables.conf and what
    upstream nftables.service would use for rules /etc/nftables.
  - /etc/protocols, /etc/services,  /etc/passwd  and/etc/group are
    needed for resolving proto, service, user and group names.
  - For /etc/resolv.conf see (14) below.

Seems to work, but has of course the disadvantage that it only
blacklists. If a user has /my-secrets it would still be readable.

Better would be something like:
> TemporaryFileSystem=3D/:ro

and selectively BindReadOnlyPaths=3D everything actually needed.
If that would be preferred, I could try to work out the required dirs.



Up to here, I've tested the settings with at least some very simply
rules file, and loading that still seemed to work.
The following I haven't tested yet,... thought I'd ask for feedback
first, whether these things would be even wanted.



13. This depends on (12) or better (TODO) below.
> ProtectHostname=3Dyes

=E2=80=9CNote that when this option is enabled for a service hostname chang=
es
no longer propagate from the system into the service=E2=80=9D... not sure
whether nftables ever uses the hostname/domainname? If so, that would
mean it could be outdated.

=E2=80=9CNote that this option does not prevent changing system hostname vi=
a
hostnamectl=E2=80=9D... not sure whether (12) makes this fully impossible b=
y
having hostnamectl non-executable... the manpage suggests using User=3D


14. Disallowing unneeded address families.
> RestrictAddressFamilies=3DAF_NETLINK AF_UNIX AF_INET AF_INET6

- This I've actually checked, too.
- In principle AF_NETLINK suffices.
- AF_INET and AF_INET6 are needed if hostnames are resolved via DNS.
Now in principle, nftables.service is anyway meant to run a at point
where no networking is available yet, so one could say this (and
/etc/resolv.conf) above is pointless.
It may however also be restarted/reloaded when the system is already
up, and then DNS would in principle work (in case the nft rules have
been modified meanwhile to include hostnames/fqdns as addresses).
Whether that should then be allowed, or whether it would be better to
fail already then (and not wait for the next boot), is of course
another questions. No strong opinions here from my side.
- Not sure whether AF_UNIX is used by anything in nft (or indirectly).

Because the above doesn't cover all cases how sockets may be accessed,
the manpage suggests to also use:
SystemCallFilter=3D@service

So in our case it would be (order matters, hope it's the right one ^^):
> SystemCallFilter=3D@service
> SystemCallFilter=3D~@mount

(haven't checked whether this is enough for nft)

Also the SystemCallArchitectures=3Dnative already set before should be
set again when this is used.


15. Deny writeable memory mappings that are also executable:
> MemoryDenyWriteExecute=3Dyes

To prevent circumvention, the manpage recommends to also set:
InaccessiblePaths=3D/dev/shm
SystemCallFilter=3D~memfd_create

Again, the already above set SystemCallArchitectures=3Dnative is
recommended, too.


16. The following, AFAIU, would all depend on letting run nft under a
non-root-user, via User=3D or rather DynamicUser=3D, which, I presume, we
could do as long as we give it CAP_NET_ADMIN.
> ProtectProc=3Dinvisible
> ProcSubset=3Dpid   (not fully sure whether that requires non-root)
> RemoveIPC=3Dyes


17. These all imply (18):
> PrivatePIDs=3Dyes
> ProtectKernelTunables=3Dyes   (not sure whether nft would need any of the=
se)
> ProtectControlGroups=3Dstrict


18. The first two options from (16) and the ones from (17) also imply
> MountAPIVFS=3Dyes
which in turn implies BindLogSockets=3Dyes .
Not sure whether MountAPIVFS=3Dyes causes any issues. Documentation kinda
implies it might only be effective if RootDirectory=3D/RootImage=3D are
used.


19. The following already default to secure values:
> KeyringMode=3D
> IgnoreSIGPIPE=3D


20. We could configure timeouts and restarting, like via TimeoutSec=3D
respectively Restart=3D, StartLimitIntervalSec=3D and StartLimitBurst=3D.
Not sure whether that would make any sense security wise, rather not.



I could/would make patches for all of the ones of your choice.
Of course if you know any cases where nft -f uses some feature which
would be restricted by the above, then please tell. :-)



Thanks,
Chris.
