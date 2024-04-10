Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A972318410C;
	Wed, 10 Apr 2024 22:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712787080; cv=none; b=o/K/8bp4O/j+mjHZNGd8TMVURcOvAU9Ivm57IyxWTiTkfbQJlgSi3adfMtR9vq4MAXuXzIUxRPBpTSHp8h9R+gYQScq9VVyAxCi9Ls0fcgKeXpYZuINnSOYXK5Kj0zAfbw2MQIoCwRmhYn9RTbpVu5vQqQ8Xr277vJ8BvmcWH34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712787080; c=relaxed/simple;
	bh=uSIGNHPH80FDsjMfRya/6PvEZZEX9bykFwMA91RBOA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A9YuLT8tVusBjloozdvSNcgSK5ndm9wQfsm9oqCOH1BKjiwbIkwQgkor9/xw5RCzjsTOXkYrh01hULSsHBkKTQObvWjDFjZSGdcyO1+wing3VvlsTJ6O7hfkBTdW+pMQpXTuwlF2BxtDCjGv79OZERRVBXqECDxFZocTh1sYXmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ngyscE2+; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ngyscE2+"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-417d14c3426so1651475e9.3;
        Wed, 10 Apr 2024 15:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712787076; x=1713391876; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m3LeUQH6aJYsfgaURLzKskwdq+qYjaj7h0bjz/8vcGg=;
        b=ngyscE2+tK40nIVjcS306QdhXGTkjUPw/3T+OfCN565DQXIvNw+M5NnOr08bYodPeR
         aVd/vNaX3hmhAcv2pvigGcPlAh463wqQ/z3baj/bALZG6RnYgJsI6iWbmL44vD7S7ans
         7KRKyewMqGSYuRbLbndfg7Cevy8RhDM2dwLqU9iyCG/DTmdSroflSLV0vmREDAlaQZlW
         CkMmVKSrSCnsPDxHK/DQVuXLg6gwcnE4J2S64dC12RQSnS9mjcB0TFf+Gi+eAXZin+7M
         RxSbHc7s8w+EZiwjl6i7YDg4/u9mGwBloEp82OLeIymDObK2FJ5tZgJRDDRzQBT8lqWq
         dnqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712787076; x=1713391876;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m3LeUQH6aJYsfgaURLzKskwdq+qYjaj7h0bjz/8vcGg=;
        b=JZVG1Zz4GfInCoLieMVO/56g2DkOj4e1Vir/4WOFXfe1EtqDjinWFe8/e8Ad1/0vMg
         db9yQK5sqZX+YTyY6a3mZ3AO1cJ4Ok2V7ulaNjVjpoRuRbZcsqj+t4OuJXgwLng1OpDH
         iEgB73ewc+WccrUAYG5BEGmmNzloXwK/19PukROnUkXj/kP2PQpEuisVkyvJovOTjS1r
         fGe6G6ln2HT6Dqulx1fDmZ1Df6tma4+RZc4WPZneiQ/h/G0127X9cASbam8NkzfXiaDn
         8EwowASVVFRPCFyBLgKrn5GWgOzYZU7c8pYsAmwFou3HU4pybHYUUUCgAUHdV44d+KMl
         xV7Q==
X-Forwarded-Encrypted: i=1; AJvYcCU+g4hAjU32BD1OhSe29MSr0L/Uolmu7cWOKHdOL/R15Bg6T9mFZ1yVDfJYRCnqbhRPh4/hbG4Nw+7zJDBM6ehxoOkggFWBDfFKRO3aOeeW
X-Gm-Message-State: AOJu0YycSNozsF2iYzh7oJidTZxYJLC+jG6ebo5O/+CKe1AjWyhCv1TA
	OsokHF/i7tKleZCSd8LeQlMKO38k9zpa6DC33whreSSunClWAXufSDzMhLjP
X-Google-Smtp-Source: AGHT+IFhJpOoHhpehzYnZrFrP6zeSLy6co5A6Rsu4MV5FWEedSFXkLbBYhUUhA/k8CgU8RD8/BbiWg==
X-Received: by 2002:a05:600c:4707:b0:416:6344:895b with SMTP id v7-20020a05600c470700b004166344895bmr2675652wmo.4.1712787076535;
        Wed, 10 Apr 2024 15:11:16 -0700 (PDT)
Received: from imac.fritz.box ([2a02:8010:60a0:0:2cff:b314:57ee:c426])
        by smtp.gmail.com with ESMTPSA id v7-20020a05600c470700b00416b2cbad06sm3531244wmo.41.2024.04.10.15.11.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Apr 2024 15:11:15 -0700 (PDT)
From: Donald Hunter <donald.hunter@gmail.com>
To: netdev@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jiri Pirko <jiri@resnulli.us>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Cc: donald.hunter@redhat.com,
	Donald Hunter <donald.hunter@gmail.com>
Subject: [PATCH net-next v2 3/3] tools/net/ynl: Add multi message support to ynl
Date: Wed, 10 Apr 2024 23:11:08 +0100
Message-ID: <20240410221108.37414-4-donald.hunter@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240410221108.37414-1-donald.hunter@gmail.com>
References: <20240410221108.37414-1-donald.hunter@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a "--multi <do-op> <json>" command line to ynl that makes it
possible to add several operations to a single netlink request payload.
The --multi command line option is repeated for each operation.

This is used by the nftables family for transaction batches. For
example:

./tools/net/ynl/cli.py \
 --spec Documentation/netlink/specs/nftables.yaml \
 --multi batch-begin '{"res-id": 10}' \
 --multi newtable '{"name": "test", "nfgen-family": 1}' \
 --multi newchain '{"name": "chain", "table": "test", "nfgen-family": 1}' \
 --multi batch-end '{"res-id": 10}'

It can also be used for bundling get requests:

./tools/net/ynl/cli.py \
 --spec Documentation/netlink/specs/nftables.yaml \
 --multi gettable '{"name": "test", "nfgen-family": 1}' \
 --multi getchain '{"name": "chain", "table": "test", "nfgen-family": 1}' \
 --output-json
[{"name": "test", "use": 1, "handle": 1, "flags": [],
 "nfgen-family": 1, "version": 0, "res-id": 2},
 {"table": "test", "name": "chain", "handle": 1, "use": 0,
 "nfgen-family": 1, "version": 0, "res-id": 2}]

Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
---
 tools/net/ynl/cli.py     | 25 ++++++++++++++--
 tools/net/ynl/lib/ynl.py | 64 +++++++++++++++++++++++++++-------------
 2 files changed, 66 insertions(+), 23 deletions(-)

diff --git a/tools/net/ynl/cli.py b/tools/net/ynl/cli.py
index f131e33ac3ee..058926d69ef0 100755
--- a/tools/net/ynl/cli.py
+++ b/tools/net/ynl/cli.py
@@ -19,13 +19,28 @@ class YnlEncoder(json.JSONEncoder):
 
 
 def main():
-    parser = argparse.ArgumentParser(description='YNL CLI sample')
+    description = """
+    YNL CLI utility - a general purpose netlink utility that uses YAML
+    specs to drive protocol encoding and decoding.
+    """
+    epilog = """
+    The --multi option can be repeated to include several do operations
+    in the same netlink payload.
+    """
+
+    parser = argparse.ArgumentParser(description=description,
+                                     epilog=epilog)
     parser.add_argument('--spec', dest='spec', type=str, required=True)
     parser.add_argument('--schema', dest='schema', type=str)
     parser.add_argument('--no-schema', action='store_true')
     parser.add_argument('--json', dest='json_text', type=str)
-    parser.add_argument('--do', dest='do', type=str)
-    parser.add_argument('--dump', dest='dump', type=str)
+
+    group = parser.add_mutually_exclusive_group()
+    group.add_argument('--do', dest='do', metavar='DO-OPERATION', type=str)
+    group.add_argument('--multi', dest='multi', nargs=2, action='append',
+                       metavar=('DO-OPERATION', 'JSON_TEXT'), type=str)
+    group.add_argument('--dump', dest='dump', metavar='DUMP-OPERATION', type=str)
+
     parser.add_argument('--sleep', dest='sleep', type=int)
     parser.add_argument('--subscribe', dest='ntf', type=str)
     parser.add_argument('--replace', dest='flags', action='append_const',
@@ -73,6 +88,10 @@ def main():
         if args.dump:
             reply = ynl.dump(args.dump, attrs)
             output(reply)
+        if args.multi:
+            ops = [ (item[0], json.loads(item[1]), args.flags or []) for item in args.multi ]
+            reply = ynl.do_multi(ops)
+            output(reply)
     except NlError as e:
         print(e)
         exit(1)
diff --git a/tools/net/ynl/lib/ynl.py b/tools/net/ynl/lib/ynl.py
index 0ba5f6fb8747..939309b8e2af 100644
--- a/tools/net/ynl/lib/ynl.py
+++ b/tools/net/ynl/lib/ynl.py
@@ -940,16 +940,11 @@ class YnlFamily(SpecFamily):
 
       return op['do']['request']['attributes'].copy()
 
-    def _op(self, method, vals, flags=None, dump=False):
-        op = self.ops[method]
-
+    def _encode_message(self, op, vals, flags, req_seq):
         nl_flags = Netlink.NLM_F_REQUEST | Netlink.NLM_F_ACK
         for flag in flags or []:
             nl_flags |= flag
-        if dump:
-            nl_flags |= Netlink.NLM_F_DUMP
 
-        req_seq = random.randint(1024, 65535)
         msg = self.nlproto.message(nl_flags, op.req_value, 1, req_seq)
         if op.fixed_header:
             msg += self._encode_struct(op.fixed_header, vals)
@@ -957,18 +952,32 @@ class YnlFamily(SpecFamily):
         for name, value in vals.items():
             msg += self._add_attr(op.attr_set.name, name, value, search_attrs)
         msg = _genl_msg_finalize(msg)
+        return msg
+
+    def _ops(self, ops):
+        reqs_by_seq = {}
+        req_seq = random.randint(1024, 65535)
+        payload = b''
+        for (method, vals, flags) in ops:
+            op = self.ops[method]
+            msg = self._encode_message(op, vals, flags, req_seq)
+            reqs_by_seq[req_seq] = (op, msg, flags)
+            payload += msg
+            req_seq += 1
 
-        self.sock.send(msg, 0)
+        self.sock.send(payload, 0)
 
         done = False
         rsp = []
+        op_rsp = []
         while not done:
             reply = self.sock.recv(self._recv_size)
             nms = NlMsgs(reply, attr_space=op.attr_set)
             self._recv_dbg_print(reply, nms)
             for nl_msg in nms:
-                if nl_msg.extack:
-                    self._decode_extack(msg, op, nl_msg.extack)
+                if nl_msg.extack and nl_msg.nl_seq in reqs_by_seq:
+                    (req_op, req_msg, req_flags) = reqs_by_seq[nl_msg.nl_seq]
+                    self._decode_extack(req_msg, req_op, nl_msg.extack)
 
                 if nl_msg.error:
                     raise NlError(nl_msg)
@@ -976,13 +985,25 @@ class YnlFamily(SpecFamily):
                     if nl_msg.extack:
                         print("Netlink warning:")
                         print(nl_msg)
-                    done = True
+
+                    (_, _, req_flags) = reqs_by_seq[nl_msg.nl_seq]
+                    if not op_rsp:
+                        rsp.append(None)
+                    elif not Netlink.NLM_F_DUMP in req_flags and len(op_rsp) == 1:
+                        rsp.append(op_rsp[0])
+                    else:
+                        rsp.append(op_rsp)
+                    op_rsp = []
+
+                    del reqs_by_seq[nl_msg.nl_seq]
+                    done = len(reqs_by_seq) == 0
                     break
 
                 decoded = self.nlproto.decode(self, nl_msg)
+                rsp_op = self.rsp_by_value[decoded.cmd()]
 
                 # Check if this is a reply to our request
-                if nl_msg.nl_seq != req_seq or decoded.cmd() != op.rsp_value:
+                if nl_msg.nl_seq not in reqs_by_seq or decoded.cmd() != rsp_op.rsp_value:
                     if decoded.cmd() in self.async_msg_ids:
                         self.handle_ntf(decoded)
                         continue
@@ -990,19 +1011,22 @@ class YnlFamily(SpecFamily):
                         print('Unexpected message: ' + repr(decoded))
                         continue
 
-                rsp_msg = self._decode(decoded.raw_attrs, op.attr_set.name)
+                rsp_msg = self._decode(decoded.raw_attrs, rsp_op.attr_set.name)
                 if op.fixed_header:
-                    rsp_msg.update(self._decode_struct(decoded.raw, op.fixed_header))
-                rsp.append(rsp_msg)
+                    rsp_msg.update(self._decode_struct(decoded.raw, rsp_op.fixed_header))
+                op_rsp.append(rsp_msg)
 
-        if not rsp:
-            return None
-        if not dump and len(rsp) == 1:
-            return rsp[0]
         return rsp
 
-    def do(self, method, vals, flags=None):
+    def _op(self, method, vals, flags):
+        ops = [(method, vals, flags)]
+        return self._ops(ops)[0]
+
+    def do(self, method, vals, flags=[]):
         return self._op(method, vals, flags)
 
     def dump(self, method, vals):
-        return self._op(method, vals, [], dump=True)
+        return self._op(method, vals, [Netlink.NLM_F_DUMP])
+
+    def do_multi(self, ops):
+        return self._ops(ops)
-- 
2.43.0

