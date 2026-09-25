Received: from mail-oi2-f12.google.com (mail-oi2-f12.google.com [74.125.231.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC1F54A0125
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Sep 2026 12:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.231.204
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790341128; cv=pass; b=W0DFCBcxr0HRl1Sd3w2c1Ou1Doa1YasXils53IcBPLN0blrH6EvtGhQR6HzCLE7CytXD7NjaU8pnWpAtj7xK9klg353qn3NE1iESKysuTHkKiRth5EV/81fJ4wchSvVflUHayl6RYNcOpG5UH7dR+QaaThnyxB6iDVn9E5FhGpo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790341128; c=relaxed/simple;
	bh=sIrWajdSI55bzVgIeQtT6ejFVBaCkARTp4mZoTp4eO0=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=ZM5p/7ljl2pHXVz9KXI2/qinYAvQZCAb94VhcqLuJ0oiNvQmPX3sxLjPuwVVe9Z4zCKkwfXIuds3kF3XnSXD6MW7iLeWEkfA1in2m/8m/8YjrGAmqpF9J7oyG8yMpjGthI8ikDIMK4SYQi3txjW6U5CzFM33S3u2H9t9rhFVBxw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZTn3u7GQ; arc=pass smtp.client-ip=74.125.231.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZTn3u7GQ"
Received: by mail-oi2-f12.google.com with SMTP id 5614622812f47-4b37a3688a2so606670b6e.0
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Sep 2026 05:58:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790341125; cv=none;
        d=google.com; s=arc-20260327;
        b=h3Yv11hjEfKAT9AunnRzyttK0fLjxi1BLLUuPfkgV0XVBPHGob37A1xK64kOn03eoe
         nVc5JFtK3cmxOmmwLtzMoAjpb/06YaBsP/UNI1VjnztSKQw3UUsIEJCC72GNsj650lr8
         EWjA1t7KCdnBuJ7OSsRCsi6riumo5RrDjJyocHszBNJzDhLfHrJ9Xfhm59984pUkMYjI
         ++eq9uKEyiagB2F0LVQyWGrJuMzd4fXbbtPc9unYphHZvkFjyTmdiuI/ceqaxQCIGVIp
         zips23psGTIHFbKNZNL2IRffde+ei7Gi6YjB8thmFLIr/KIi4ZWSMxcfELg1aQVgNllq
         uBWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=0sTaZOJGNQAhDW/2ta0aKKuqOnO+M0R8a1b5awxlD+s=;
        fh=/FlCOxlFKSwqRaYO54pdJvDR1jnt606WnNMZ1UBh+k8=;
        b=KWf+jc0cC+knK3s+q9fk6Kg4qbi7SIumWjHYDLbbFnV0Vvie0ZP+PETzDm4IQsQlSx
         plG+VaTeuHSM0immK6bn/8/erwkhZPcK12WBceCk+oxFgfdBaSa6l6/CcYSzTyDAbZ+T
         zKVCExk0jXtv7kVQj/7w89JuMEOStIHYOHCy4tvvzor4ucq8jZC9IJwR/6OLjNQDWlLy
         y0jLKBOaNqKkh5J2z3Qei7K6ugnhO5lQRZ9u+axrtaQlUTQ4NHE++8Ze9+r37BzzjH97
         XbZPCFLrD8THjP0vXd7Ii0gamAJhoMmZtZEVj8NpiA7IeGkkchJUbwvVCil2nTpPXq1i
         HsWQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790341125; x=1790945925; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0sTaZOJGNQAhDW/2ta0aKKuqOnO+M0R8a1b5awxlD+s=;
        b=ZTn3u7GQ3Blvti+LYNSSdiK+edFwLYlLnc+uvf/MkgIY7SyWkRDAmz9YmlT8Pks3Zg
         XYLrAwc5JgZ+LW8xrAlnKWZtLm6Pg43JPrWtjfyb15EPVWUHSVyvZCcEXWNum5RhiAR3
         LYubxQ2q2vXYBEUPkKBxruXTyFwBfN0nr+s2qmj/1KqWVRpQ7UpQnXu4AlZk9O1el7xy
         C5ASLcuG1+dWgoEjhzHy6GgD/r5Fl/GLmk/QGwdeaG4Re74QVvbFWpGvJRI1SnQRz1cn
         f37a88cgcGrmgF2r5aSibEOrvjloWrK0r+VHx+X2EtUJ4sPQsYLafI2dSDHn+cm1NfLn
         qx2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790341125; x=1790945925;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=0sTaZOJGNQAhDW/2ta0aKKuqOnO+M0R8a1b5awxlD+s=;
        b=hzNsRcUxfdM6r72SKmVvnHwP55gTEFmamn2EZXpmr7qmqvZDjrk5KXypvoS6xucqFf
         X3y4T9tLD0IGuXVDNWMAPeFTf7bQtGfvizsfPkkGdaPWuacE2MDYpdF+pGsvFI3OAdDx
         O13ok4NfRJaenHjFfpbiQt9sm8a0PvhvUYu1yuDvSL0llogktbvrCNSe4poYzXoOymEa
         TqDuWvQRNScJoA6LmQj522yI+1FxkGXWTAfoXKCjUFobyGv+yXc6oETYfzY76+rW5pjA
         BA5Uu3wM0iqxwuTCemJyxrXnuiPPWGh5dtClvZ9C6ijvsac8CK1JFshS1aSB2KL0cSjb
         mY9Q==
X-Gm-Message-State: AFuF++mFIdigrSwFk0sONpA46sYKeDJmk3L0NlmGj8zGOCbCi3dx7s+t
	GfGkGxJ7M2dIF5LIJF1a+xwTofnos6om/+zInhSNfgxz2vsn82zjs95TLX/VUn8U74wNhFij6xu
	Z6CfEYAfWycg/yYco/cob72S/AgqYY4g45c3L
X-Gm-Gg: AYBFou0BNSGku/Kc21aNZJ95k80cLQP4RApP0gCV19Fqu5DjOTYV1x6omPAPev8Hr0T
	gMnWcpCkLNjDYHiua/6qP/OHGPYf+WnO2QzeUvBj6tt1/C/6Ka1ysaPV35pGhLQm+P8vaBvvOxM
	ikkRtOz+L0kjTGMtPayONBrk9KwQnDgYL8v7UuTAG3Jk4rzFzXoQR4DOfA5Z6EHFpX+nL50Qht4
	rJ/eX8zaa/ES1Wq6B/WSoXa6hQCaV6CzS9SiGNcLukRM/HpkxrNN7fqOA4LA6LO6WVcfclsVjYD
	4rDfM7NA/TQ3HHemzDQJrjEf73t9JaOfAESzaZD9PmT5yKp0YEx7o2+TT7kLfiFKFh+YLwxKjQJ
	xZt3gYigwQfEAnSBzFF5m
X-Received: by 2002:a05:6808:238e:b0:4c2:9b5a:cc20 with SMTP id
 5614622812f47-4d728e2e485mr5420313b6e.0.1790341125583; Fri, 25 Sep 2026
 05:58:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Antonio Ojea <antonio.ojea.garcia@gmail.com>
Date: Fri, 25 Sep 2026 14:58:09 +0200
X-Gm-Features: AclHuK9c3GKHvxjaHfi-iBLjrRmzPFraRl5c1wa-qtFU0q67eNUlwFpQ0ibDlCA
Message-ID: <CABhP=tYtCyr-qzL==98nkmDVZr6x+f8E26V1AAOpMXgZgt0vAQ@mail.gmail.com>
Subject: nf_queue: hook changes drop or re-queue packets waiting in any nfqueue
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, 
	Dan Winship <danwinship@redhat.com>
Content-Type: multipart/mixed; boundary="000000000000d15545065c4e468d"

--000000000000d15545065c4e468d
Content-Type: text/plain; charset="UTF-8"

Hi,

deleting an nftables base chain drops every packet that is waiting for
a verdict in any nfqueue of the network namespace, including packets
queued by hooks of other tables and other families. Adding a base chain
in front of the one that queued a packet makes the packet traverse the
queuing hook again after the verdict, so userspace sees it twice.

We found the first problem in kube-network-policies and kindnet
(Kubernetes network policy and CNI agents built on nfqueue) [1]. Their
nftables sync did "add table; delete table; add table" to replace the
ruleset, and every sync lost the connections being evaluated at that
moment. The userspace symptom is the verdict for the dropped packet
failing asynchronously with -ENOENT:

  "Could not receive message"
  error="netlink receive: no such file or directory"

The add/delete/add idiom was my mistake. The documented way to replace
a ruleset atomically is "flush table" (or "flush chain") in the same
transaction, which keeps the base chains and their hooks, and we need
to change that. However, it does not cover upgrades. A table written by an
older version may have a chain and/or sets the new version
no longer uses. Removing them still requires deleting the table, or
the chain, at least once at startup, with the same effect on every
nfqueue in the namespace. Suggestions on how to handle that case are
welcome.

Independently of fixing it in our projects, any other component will
trigger the same problem that applies to any nfqueue consumer.

Analysis assisted by AI (v6.18-rc1, unchanged in current mainline)
--------------------------------------------------

Deleting a base chain ends in __nf_unregister_net_hook(), which after
shrinking the hook array calls nf_queue_nf_hook_drop(net)
(net/netfilter/core.c:522). nfqnl_nf_hook_drop()
(net/netfilter/nfnetlink_queue.c:1184) walks every nfqnl_instance of
the namespace and calls nfqnl_flush(inst, NULL, 0), which reinjects all
entries with NF_DROP. Nothing in that path looks at which hook was
removed, which table owned it, or which hook queued each entry.

The reason is nf_queue_entry::hook_index: the entry stores its position
in the nf_hook_entries array of its hook point, and nf_reinject()
resumes the traversal from that index. Any change to the array makes
the index stale, so on unregister everything queued is dropped.

Registering a hook does not drop anything, but it also changes the
array. When the new hook sorts before the queuing one, nf_reinject()
finds the new hook at hook_index, does ++i, and nf_iterate() runs the
queuing hook again. The packet is queued a second time.

History:

  039b40ee5854 ("netfilter: nf_queue: only call synchronize_net twice
  if nf_queue is active"), v4.12, removed the nf_hook_cmp() filter from
  nfqnl_nf_hook_drop() so that only entries queued by the removed hook
  were dropped. The commit message says: "For the rare case of base
  chain being unregistered or module removal while nfqueue is in use
  the extra hiccup due to the packet drops isn't a big deal."

  960632ece694 ("netfilter: convert hook list to an array"), v4.14,
  replaced the hook pointer in the entry with hook_index.

With nftables base chains managed by userspace daemons, unregistering
a hook is no longer rare, at least not as rare as before, and it happens in
namespaces where unrelated nfqueue consumers are running.

Reproducer
----------

The attached script (AI assisted) uses the nf_queue helper from
tools/testing/selftests/net/netfilter (gcc -o nf_queue nf_queue.c -lmnl).
It queues 20 UDP packets to queue 1 from an inet output chain, the
helper delays every verdict by 100 ms so most packets are waiting when
the ruleset is changed, and it checks that all 20 are delivered and that
the helper received each one exactly once.

  $ sudo NF_QUEUE=./nf_queue ./nfqueue-hook-drop.sh
  PASS: no ruleset change
        sent 20, queued 20, delivered 20
  PASS: delete regular chain (no hook) of unrelated table
        sent 20, queued 20, delivered 20
  PASS: add base chain to unrelated table (ip6 input)
        sent 20, queued 20, delivered 20
  PASS: add base chain after the queuing one (output prio 100)
        sent 20, queued 20, delivered 20
  FAIL: add base chain before the queuing one (output prio raw)
        sent 20, queued 37, delivered 20
  FAIL: delete base chain of unrelated table (ip6 prerouting)
        sent 20, queued ?, delivered 3
        nf_queue (exit status 1): mnl_cb_run: No such file or directory
  FAIL: delete unrelated table (ip6, no queue rule)
        sent 20, queued ?, delivered 3
        nf_queue (exit status 1): mnl_cb_run: No such file or directory

The "unrelated" table is ip6 with a prerouting base chain and no queue
rule. Deleting it drops the packets queued by the inet output chain of
another table. The "before" case shows the 17 packets that were waiting
being queued a second time. Reproduced on 7.1.6; the Go reproducer in
[1] shows the same drops on 7.0.12, also when the table being recreated
is not the one with the queue rule.

I can turn this into a test case for nft_queue.sh if that helps.

Happy to test patches or to send a selftest.

Thanks,
Antonio

[1] https://github.com/kubernetes-sigs/kube-network-policies/issues/402
    (kernel call path and a standalone Go reproducer by Ben Dwyer,
    who found the root cause)

--000000000000d15545065c4e468d
Content-Type: text/plain; charset="US-ASCII"; name="nfqueue-hook-drop.sh.txt"
Content-Disposition: attachment; filename="nfqueue-hook-drop.sh.txt"
Content-Transfer-Encoding: base64
Content-ID: <f_mugwimbi0>
X-Attachment-Id: f_mugwimbi0

IyEvYmluL2Jhc2gKIyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMAojCiMgUGFja2V0
cyB3YWl0aW5nIGZvciBhIHZlcmRpY3QgaW4gYW4gbmZxdWV1ZSBkbyBub3Qgc3Vydml2ZSBjaGFu
Z2VzIHRvIHRoZQojIG5ldGZpbHRlciBob29rIGFycmF5IG9mIHRoZSBuZXR3b3JrIG5hbWVzcGFj
ZToKIwojICAtIHVucmVnaXN0ZXJpbmcgYW55IGhvb2sgKGRlbGV0aW5nIGFueSBuZnRhYmxlcyBi
YXNlIGNoYWluLCBldmVuIG9uZSBvZgojICAgIGFuIHVucmVsYXRlZCB0YWJsZSBvciBmYW1pbHkp
IGRyb3BzIGV2ZXJ5IHBhY2tldCBxdWV1ZWQgaW4gZXZlcnkKIyAgICBuZnF1ZXVlIGluc3RhbmNl
IG9mIHRoZSBuYW1lc3BhY2UgKG5mcW5sX25mX2hvb2tfZHJvcCgpKS4KIyAgLSByZWdpc3Rlcmlu
ZyBhIGhvb2sgaW4gZnJvbnQgb2YgdGhlIG9uZSB0aGF0IHF1ZXVlZCB0aGUgcGFja2V0IG1ha2Vz
CiMgICAgbmZfcmVpbmplY3QoKSByZXN1bWUgYXQgYSBzdGFsZSBpbmRleCwgc28gdGhlIHBhY2tl
dCB0cmF2ZXJzZXMgdGhlCiMgICAgcXVldWluZyBob29rIGFnYWluIGFuZCBpcyBxdWV1ZWQgYSBz
ZWNvbmQgdGltZS4KIwojIE5lZWRzIHRoZSBuZl9xdWV1ZSBoZWxwZXIgZnJvbSB0b29scy90ZXN0
aW5nL3NlbGZ0ZXN0cy9uZXQvbmV0ZmlsdGVyOgojICAgZ2NjIC1vIG5mX3F1ZXVlIG5mX3F1ZXVl
LmMgLWxtbmwKIwojIFVzYWdlOiBORl9RVUVVRT0uL25mX3F1ZXVlIC4vbmZxdWV1ZS1ob29rLWRy
b3Auc2gKCk5GX1FVRVVFPSR7TkZfUVVFVUU6LS4vbmZfcXVldWV9ClBBQ0tFVFM9MjAKcmV0PTAK
Cm5zPSJuZnEtJChta3RlbXAgLXUgWFhYWFhYKSIKdG1wPSQobWt0ZW1wKQoKY2xlYW51cCgpIHsK
CWlwIG5ldG5zIHBpZHMgIiRucyIgMj4vZGV2L251bGwgfCB4YXJncyAtciBraWxsIDI+L2Rldi9u
dWxsCglpcCBuZXRucyBkZWwgIiRucyIgMj4vZGV2L251bGwKCXJtIC1mICIkdG1wIgp9CnRyYXAg
Y2xlYW51cCBFWElUCgppZiBbICEgLXggIiRORl9RVUVVRSIgXTsgdGhlbgoJZWNobyAiU0tJUDog
JE5GX1FVRVVFIG5vdCBmb3VuZCwgYnVpbGQgdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvbmV0L25l
dGZpbHRlci9uZl9xdWV1ZS5jIiA+JjIKCWV4aXQgNApmaQoKaXAgbmV0bnMgYWRkICIkbnMiIHx8
IGV4aXQgNAppcCAtbmV0ICIkbnMiIGxpbmsgc2V0IGxvIHVwCgojIFRoZSBVRFAgcGFja2V0cyB0
byBwb3J0IDEyMzQ1IHRoYXQgdGhlIG5hbWVzcGFjZSBzZW5kcyB0byBpdHNlbGYgYXJlIHF1ZXVl
ZAojIHRvIHF1ZXVlIDEgYXQgdGhlIElQdjQgb3V0cHV0IGhvb2ssIHdpdGhvdXQgYnlwYXNzIHNv
IHRoZXkgd2FpdCBmb3IgdGhlCiMgdmVyZGljdC4gVGhlIGNvdW50ZXIgaW4gdGhlIGlucHV0IGNo
YWluIHRlbGxzIGhvdyBtYW55IHdlcmUgZGVsaXZlcmVkLgojICJ1bnJlbGF0ZWQiIGlzIGEgdGFi
bGUgb2YgYW5vdGhlciBmYW1pbHkgd2l0aCBhIGJhc2UgY2hhaW4gYW5kIG5vIHF1ZXVlIHJ1bGUu
CnNldHVwX3J1bGVzZXQoKSB7CglpcCBuZXRucyBleGVjICIkbnMiIG5mdCAtZiAtIDw8RU9GCmZs
dXNoIHJ1bGVzZXQKdGFibGUgaW5ldCBuZnF0ZXN0IHsKCWNoYWluIG91dHB1dCB7CgkJdHlwZSBm
aWx0ZXIgaG9vayBvdXRwdXQgcHJpb3JpdHkgZmlsdGVyOyBwb2xpY3kgYWNjZXB0OwoJCXVkcCBk
cG9ydCAxMjM0NSBxdWV1ZSB0byAxCgl9CgljaGFpbiBpbnB1dCB7CgkJdHlwZSBmaWx0ZXIgaG9v
ayBpbnB1dCBwcmlvcml0eSBmaWx0ZXI7IHBvbGljeSBhY2NlcHQ7CgkJdWRwIGRwb3J0IDEyMzQ1
IGNvdW50ZXIgbmFtZSBkZWxpdmVyZWQKCX0KCWNvdW50ZXIgZGVsaXZlcmVkIHt9Cn0KdGFibGUg
aXA2IHVucmVsYXRlZCB7CgljaGFpbiBwcmVyb3V0aW5nIHsKCQl0eXBlIGZpbHRlciBob29rIHBy
ZXJvdXRpbmcgcHJpb3JpdHkgZmlsdGVyOyBwb2xpY3kgYWNjZXB0OwoJfQoJY2hhaW4gcmVndWxh
ciB7Cgl9Cn0KRU9GCn0KCmRlbGl2ZXJlZCgpIHsKCWlwIG5ldG5zIGV4ZWMgIiRucyIgbmZ0IGxp
c3QgY291bnRlciBpbmV0IG5mcXRlc3QgZGVsaXZlcmVkIHwKCQlzZWQgLW4gJ3MvLipwYWNrZXRz
IFwoWzAtOV0qXCkgLiovXDEvcCcKfQoKIyBxdWV1ZWQgaXMgaG93IG1hbnkgcGFja2V0cyB0aGUg
aGVscGVyIHJlY2VpdmVkLCBwcmludGVkIGJ5IG5mX3F1ZXVlIC1jIG9uCiMgYSBjbGVhbiBleGl0
LiBJdCBleGl0cyBlYXJseSBvbiBFTk9FTlQsIGEgdmVyZGljdCBmb3IgYSBwYWNrZXQgdGhlIGtl
cm5lbAojIGFscmVhZHkgZHJvcHBlZCwgc28gdGhlIGNvdW50IGlzIG5vdCBhdmFpbGFibGUgaW4g
dGhhdCBjYXNlLgpxdWV1ZWQoKSB7CglzZWQgLW4gJ3MvXlwoWzAtOV0qXCkgcGFja2V0cyB0b3Rh
bCQvXDEvcCcgIiR0bXAiCn0KCm5mX3F1ZXVlX3dhaXQoKSB7Cglmb3IgXyBpbiAkKHNlcSA1MCk7
IGRvCgkJaWYgaXAgbmV0bnMgZXhlYyAiJG5zIiBncmVwIC1xICdeICoxICcgL3Byb2MvbmV0L25l
dGZpbHRlci9uZm5ldGxpbmtfcXVldWU7IHRoZW4KCQkJcmV0dXJuIDAKCQlmaQoJCXNsZWVwIDAu
MQoJZG9uZQoJZWNobyAiRkFJTDogbmZfcXVldWUgZGlkIG5vdCBiaW5kIHF1ZXVlIDEiID4mMgoJ
ZXhpdCAxCn0KCiMgcnVuX2Nhc2UgPGRlc2NyaXB0aW9uPiA8bmZ0IGNvbW1hbmQuLi4+CiMKIyBT
ZW5kcyBQQUNLRVRTIHBhY2tldHMgd2hpbGUgdGhlIGhlbHBlciBkZWxheXMgZXZlcnkgdmVyZGlj
dCBieSAxMDBtcywgc28KIyBtb3N0IG9mIHRoZW0gYXJlIHN0aWxsIHdhaXRpbmcgd2hlbiB0aGUg
bmZ0IGNvbW1hbmQgcnVucywgYW5kIGNoZWNrcyB0aGF0CiMgYWxsIG9mIHRoZW0gYXJlIGRlbGl2
ZXJlZCBhbmQgdGhhdCBlYWNoIG9uZSB3YXMgcXVldWVkIGV4YWN0bHkgb25jZS4KcnVuX2Nhc2Uo
KSB7Cglsb2NhbCBkZXNjPSIkMSIKCXNoaWZ0CgoJc2V0dXBfcnVsZXNldCB8fCBleGl0IDEKCglp
cCBuZXRucyBleGVjICIkbnMiICIkTkZfUVVFVUUiIC1jIC1xIDEgLWQgMTAwIC10IDIgPiIkdG1w
IiAyPiYxICYKCWxvY2FsIHBpZD0kIQoJbmZfcXVldWVfd2FpdAoKCWlwIG5ldG5zIGV4ZWMgIiRu
cyIgYmFzaCAtYyAiCgkJZm9yIGkgaW4gXCQoc2VxICRQQUNLRVRTKTsgZG8gZWNobyB4ID4vZGV2
L3VkcC8xMjcuMC4wLjEvMTIzNDU7IGRvbmUiCglzbGVlcCAwLjMgIyBhIGZldyB2ZXJkaWN0cyBs
YW5kLCB0aGUgcmVzdCBvZiB0aGUgcGFja2V0cyB3YWl0IGluIHRoZSBxdWV1ZQoKCWlwIG5ldG5z
IGV4ZWMgIiRucyIgbmZ0ICIkQCIgPi9kZXYvbnVsbAoKCXdhaXQgIiRwaWQiCglsb2NhbCBzdGF0
dXM9JD8gZ290X2RlbGl2ZXJlZCBnb3RfcXVldWVkCglnb3RfZGVsaXZlcmVkPSQoZGVsaXZlcmVk
KQoJZ290X3F1ZXVlZD0kKHF1ZXVlZCkKCglpZiBbICIkZ290X2RlbGl2ZXJlZCIgPSAiJFBBQ0tF
VFMiIF0gJiYgWyAiJGdvdF9xdWV1ZWQiID0gIiRQQUNLRVRTIiBdOyB0aGVuCgkJZWNobyAiUEFT
UzogJGRlc2MiCgllbHNlCgkJZWNobyAiRkFJTDogJGRlc2MiCgkJcmV0PTEKCWZpCgllY2hvICIg
ICAgICBzZW50ICRQQUNLRVRTLCBxdWV1ZWQgJHtnb3RfcXVldWVkOi0/fSwgZGVsaXZlcmVkICRn
b3RfZGVsaXZlcmVkIgoJZ3JlcCAtdiAnXiQnICIkdG1wIiB8IGdyZXAgLXYgJ15ob29rXHxwYWNr
ZXRzIHRvdGFsJyB8IHNlZCAicy9eLyAgICAgIG5mX3F1ZXVlIChleGl0IHN0YXR1cyAkc3RhdHVz
KTogLyIKfQoKcnVuX2Nhc2UgIm5vIHJ1bGVzZXQgY2hhbmdlIiBcCglsaXN0IHJ1bGVzZXQKcnVu
X2Nhc2UgImRlbGV0ZSByZWd1bGFyIGNoYWluIChubyBob29rKSBvZiB1bnJlbGF0ZWQgdGFibGUi
IFwKCWRlbGV0ZSBjaGFpbiBpcDYgdW5yZWxhdGVkIHJlZ3VsYXIKcnVuX2Nhc2UgImFkZCBiYXNl
IGNoYWluIHRvIHVucmVsYXRlZCB0YWJsZSAoaXA2IGlucHV0KSIgXAoJYWRkIGNoYWluIGlwNiB1
bnJlbGF0ZWQgaW5wdXQgJ3sgdHlwZSBmaWx0ZXIgaG9vayBpbnB1dCBwcmlvcml0eSBmaWx0ZXI7
IH0nCnJ1bl9jYXNlICJhZGQgYmFzZSBjaGFpbiBhZnRlciB0aGUgcXVldWluZyBvbmUgKG91dHB1
dCBwcmlvIDEwMCkiIFwKCWFkZCBjaGFpbiBpbmV0IG5mcXRlc3QgbGF0ZSAneyB0eXBlIGZpbHRl
ciBob29rIG91dHB1dCBwcmlvcml0eSAxMDA7IH0nCnJ1bl9jYXNlICJhZGQgYmFzZSBjaGFpbiBi
ZWZvcmUgdGhlIHF1ZXVpbmcgb25lIChvdXRwdXQgcHJpbyByYXcpIiBcCglhZGQgY2hhaW4gaW5l
dCBuZnF0ZXN0IGVhcmx5ICd7IHR5cGUgZmlsdGVyIGhvb2sgb3V0cHV0IHByaW9yaXR5IHJhdzsg
fScKcnVuX2Nhc2UgImRlbGV0ZSBiYXNlIGNoYWluIG9mIHVucmVsYXRlZCB0YWJsZSAoaXA2IHBy
ZXJvdXRpbmcpIiBcCglkZWxldGUgY2hhaW4gaXA2IHVucmVsYXRlZCBwcmVyb3V0aW5nCnJ1bl9j
YXNlICJkZWxldGUgdW5yZWxhdGVkIHRhYmxlIChpcDYsIG5vIHF1ZXVlIHJ1bGUpIiBcCglkZWxl
dGUgdGFibGUgaXA2IHVucmVsYXRlZAoKZXhpdCAkcmV0Cg==
--000000000000d15545065c4e468d--
