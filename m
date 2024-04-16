Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 619D31386D6;
	Tue, 16 Apr 2024 19:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713295956; cv=none; b=XrUa7k8ulH0LaR9t450jqc2qKo36E7zGiCEEcx+swGDtICU6kNAKPwaeYKmf3CtMT+7/KDkE4/ub1idUtHoodK7hQwTlg0N2s2VT1TXPqDnh7oy/dOvbgEtCTpErlklCmuuHprlwhT0x4eCH06gPz5RqJa0pf8jazQJb4UpAoPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713295956; c=relaxed/simple;
	bh=JmklNJkXVbBt0Hk1Q+ree0UoA88bHG2P1eTirKF3fUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tp+Ihl7QX5wjTWrv0pxBrK1oN6ZC3DjNsafNel7zHq0V0t/FUBIEyg0L2uw01egmSNGmS3zvecGv1WUgNzfh7/DZedhWHxIUa1BiYnrF/1eHfV0zlRmvpk+21nO7ESUOYyuwQY7CKX3jRdQn9CosFNM2mNYJ5PGP4G1aGR2Qbb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SahGBjtL; arc=none smtp.client-ip=209.85.222.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SahGBjtL"
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-78d62c1e82bso322049385a.3;
        Tue, 16 Apr 2024 12:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713295953; x=1713900753; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c8y7IngMiFe8wB8ombVLCmxifTnM5mL9MitMGDY7XhQ=;
        b=SahGBjtL0x9DXQunVYdoP3DNXKHZ1LTRRerTdUb9AgqZBW+UNj3ad/+KkFCGlQkQOf
         QwjXpd1BHlA7mXkzeJTxuuc/dStPqr0liGXkMbnOp4yJaO5MJEzMujTZwEbrmYpM8zHl
         V6Z9/9fN9HtARm9hybzlj8+poumIuY1YJjYS8qVxEeTN5VQdiBVXISwKDZg8S/4Gv+mC
         CPvwZA6HM89BnHDIe4TpYSRraZc2b3lXbeMTQQAUaCPixqGQNdUQNLQHEZHLYIuTmpo3
         /1bmJLLp0cJrjoXN615xf9wC4hYau0vQV23MveFVjdl3+O++79PlDX9kLzqsuiHQzlmc
         G6uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713295953; x=1713900753;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c8y7IngMiFe8wB8ombVLCmxifTnM5mL9MitMGDY7XhQ=;
        b=l6tXvx7cBGwF614V+ucQksVWVuzJKqBJTHej+JGW9rLmMsFGE/ZOeWfNugp6MY/K+4
         H4nI1kzFwLGGqY7BDYo+jqmtrPJ461sdHiZgE1cpIUhB69xoCnUmDXcn6s2zBzEqf/qO
         evTVdpA+44uzxonsq89GXPQs9zsy0/1pM5NIPkLTYqwOE8xshF2LkExoCoyg7EO6lLy+
         Y5HiUMJPYw8grmXFYw0xZN3I/csijUsY0JEH9aaaMTJdnH/LEUX0sqkxPc2b3wmFY+7D
         o+ic2IGMu/6RMQC8FL874mPuxhWGX6MqXU0tyXVXl5sLkM60gLjY58OOznjxfdMryHSL
         5DPg==
X-Forwarded-Encrypted: i=1; AJvYcCXXHMVJ7FPyef6HqQD8q0U3HluJX8o1q7JylNomM8EdhYrftwhJ4qF3DzRLrHx122mWQrqNWUl2tBz9kUuau8KeYz2nnZonEfmyrH7ZORao
X-Gm-Message-State: AOJu0Yx5qxFekBtkfXlFxfxrQATuaYU5A0EzXe+V5+YHOvr7jclWRqGi
	0Mkayf5n5+unVK+DIKN7QGy7CXSPcQm5bBZ8KtVODdaaEGOk9wVLLy/OWdOX
X-Google-Smtp-Source: AGHT+IENa831t8vCHTpsFDldBlMLSOZ+0DbkMP6jBeOUHyNJrDr6wERJaYcKLYW5ux1kjou3DQ2VKw==
X-Received: by 2002:ad4:5969:0:b0:69b:7a67:d3ea with SMTP id eq9-20020ad45969000000b0069b7a67d3eamr9174838qvb.17.1713295952677;
        Tue, 16 Apr 2024 12:32:32 -0700 (PDT)
Received: from imac.redhat.com ([88.97.103.74])
        by smtp.gmail.com with ESMTPSA id p12-20020a0cfacc000000b0069b52026a19sm6901757qvo.25.2024.04.16.12.32.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Apr 2024 12:32:32 -0700 (PDT)
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
Subject: [PATCH net-next v3 2/4] tools/net/ynl: Add multi message support to ynl
Date: Tue, 16 Apr 2024 20:32:13 +0100
Message-ID: <20240416193215.8259-3-donald.hunter@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240416193215.8259-1-donald.hunter@gmail.com>
References: <20240416193215.8259-1-donald.hunter@gmail.com>
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
[None, None, None, None]

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
 tools/net/ynl/cli.py     | 25 ++++++++++++--
 tools/net/ynl/lib/ynl.py | 70 ++++++++++++++++++++++++++++------------
 2 files changed, 71 insertions(+), 24 deletions(-)

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
index a67f7b6fef92..a45e53ab0dd9 100644
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
@@ -976,13 +985,27 @@ class YnlFamily(SpecFamily):
                     if nl_msg.extack:
                         print("Netlink warning:")
                         print(nl_msg)
-                    done = True
+
+                    (_, _, req_flags) = reqs_by_seq[nl_msg.nl_seq]
+                    if Netlink.NLM_F_DUMP in req_flags:
+                        rsp.append(op_rsp)
+                    elif not op_rsp:
+                        rsp.append(None)
+                    elif len(op_rsp) == 1:
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
@@ -990,21 +1013,26 @@ class YnlFamily(SpecFamily):
                         print('Unexpected message: ' + repr(decoded))
                         continue
 
-                rsp_msg = self._decode(decoded.raw_attrs, op.attr_set.name)
+                rsp_msg = self._decode(decoded.raw_attrs, rsp_op.attr_set.name)
                 if op.fixed_header:
-                    rsp_msg.update(self._decode_struct(decoded.raw, op.fixed_header))
-                rsp.append(rsp_msg)
+                    rsp_msg.update(self._decode_struct(decoded.raw, rsp_op.fixed_header))
+                op_rsp.append(rsp_msg)
 
-        if dump:
-            return rsp
-        if not rsp:
-            return None
-        if len(rsp) == 1:
-            return rsp[0]
         return rsp
 
+    def _op(self, method, vals, flags=None, dump=False):
+        req_flags = flags or []
+        if dump:
+            req_flags.append(Netlink.NLM_F_DUMP)
+
+        ops = [(method, vals, req_flags)]
+        return self._ops(ops)[0]
+
     def do(self, method, vals, flags=None):
         return self._op(method, vals, flags)
 
     def dump(self, method, vals):
-        return self._op(method, vals, [], dump=True)
+        return self._op(method, vals, dump=True)
+
+    def do_multi(self, ops):
+        return self._ops(ops)
-- 
2.44.0

