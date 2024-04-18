Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0390C15B96D;
	Thu, 18 Apr 2024 10:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713437268; cv=none; b=MY0HJM7D2HBZHRJVjRZGJql3RSkNTvPdZHSey+yFYCveSbwdW2wls3l6fYlC7/l3ISFTZTdZUJt1M2ZLYAy3Iixoho1eypfLJ8p9sGEU+CD5ZTJzIuYSIXG/dLfhqIOif27Ho3TWoHS3FB5FoUXqbR0hNMD4QutYBVAHGeitaIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713437268; c=relaxed/simple;
	bh=s6LyhD8AJWipl0VmaL8dkijfb1Xa2oH1fRtSeUXRZAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dwHZjnO5s5n2Dyo//QvugriCCxvrGNu7E//EvGrZs+xvdNqm0rUUeNGdij7XxLJacdS5AkSajpBRrXxurNdKJmx6/4WH+eWfLEGoxqbxHkXNaIpRVelS7iwdD9MDfHemuPAP8fw/jeEw/d55/yFvO9Mc8GydLSbQZ/weKn8WHww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H3vp3ul4; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H3vp3ul4"
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2da888330b1so11193551fa.1;
        Thu, 18 Apr 2024 03:47:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713437265; x=1714042065; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GcEA0LphdWwI7UsvN6gyQsJJSneCdJlXj2NXz28XGDc=;
        b=H3vp3ul4ED+9L4Cd/t6w8VzSAckD5itGE/7R9PO065rzwNvANIJB+ktznTmtmHmr8r
         Ff05z+QsatOZXw3FLTSo9jWe7lN/YFt8XQtun5RB0HFcygu3DKXfgZZgBFpN+vFXO0ST
         aBdWXJ5SaRT+KtHY/SLGSBo1qXB97cCVrovSsMj6apaDUwtuyGDwcc0n+TwZ4fkcI2yx
         oIq56UBRYLDFpJBR+eppRI5256DfBGwuXNiH/BnyqiOKB9rY1g391HqXsn/YDaH0mhwl
         IfMQzMARXwCxGyVz78fm/p4vJaoGZNcffXX7bstHbD912EvofnPPgyqLrCAwIOoscy0y
         SjiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713437265; x=1714042065;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GcEA0LphdWwI7UsvN6gyQsJJSneCdJlXj2NXz28XGDc=;
        b=iPOiVo2WzJMPyzFrVhBYdumyRievtcM7/2q+vjMAqu/Ht2loIzGGFyDgw8Pfxs8Bhb
         9otV1QjeBUTa+vC7i3i6dMBhw+7jfzH/eMHHuc7fpu2g20V4ff8OU8R/wahQmomRpXzo
         Z00j0dovFNXG/MCiYP+wkFIXwSgegcte5wILBCinkQpirKK57s3pMLoRjZ/ccJD8xh0b
         dBlY5T2GpO3fpO2Q3/ADOuPWFewiRQLucGHDR/nG8XZHfzOOHASRSfUKJbk6Nq0cBqey
         Wg3VoVOBeQxoK77OALnYFOKQonTHeh43TtE7ANadsOkxvO3wlI9ZQHMlFDxfENBiVCPU
         eOiA==
X-Forwarded-Encrypted: i=1; AJvYcCVWgBCg55e1Mr4CQOIrn4I8JspdD7Dqs0WU6SX4UhfdumtoffKyfHhmi8HuNZT5AyqQhu6LXeKmz08U+2y0qCL2RsN6Jd83Yx0ysrU41EMX
X-Gm-Message-State: AOJu0Ywh9jIKoNZI+qcHx8bv+yAhJMDa/XEuOHCL3AGO9t3hIgWAJNcm
	0ZFAErjVmEyqkGvNes/kK2P/kAzZ7ZsmxQEMccLWLvpDuf0dd8qaZeNbCxW7
X-Google-Smtp-Source: AGHT+IEc94ljVbVRwtz/TDnC7rEaKqcxKlk9Gx1php081UtspHpZmNGihKQuqis8j2RsjWtGAMrlYg==
X-Received: by 2002:a2e:9bd2:0:b0:2d4:5321:9daf with SMTP id w18-20020a2e9bd2000000b002d453219dafmr1289013ljj.44.1713437264502;
        Thu, 18 Apr 2024 03:47:44 -0700 (PDT)
Received: from imac.fritz.box ([2a02:8010:60a0:0:702a:9979:dc91:f8d0])
        by smtp.gmail.com with ESMTPSA id f11-20020a05600c4e8b00b00417ee886977sm6135807wmq.4.2024.04.18.03.47.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Apr 2024 03:47:44 -0700 (PDT)
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
Subject: [PATCH net-next v4 3/4] tools/net/ynl: Add multi message support to ynl
Date: Thu, 18 Apr 2024 11:47:36 +0100
Message-ID: <20240418104737.77914-4-donald.hunter@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240418104737.77914-1-donald.hunter@gmail.com>
References: <20240418104737.77914-1-donald.hunter@gmail.com>
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
 tools/net/ynl/cli.py     | 25 +++++++++++++--
 tools/net/ynl/lib/ynl.py | 68 +++++++++++++++++++++++++++++-----------
 2 files changed, 71 insertions(+), 22 deletions(-)

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
index a3ec7a56180a..ea48f83c2e84 100644
--- a/tools/net/ynl/lib/ynl.py
+++ b/tools/net/ynl/lib/ynl.py
@@ -938,16 +938,11 @@ class YnlFamily(SpecFamily):
 
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
@@ -955,18 +950,36 @@ class YnlFamily(SpecFamily):
         for name, value in vals.items():
             msg += self._add_attr(op.attr_set.name, name, value, search_attrs)
         msg = _genl_msg_finalize(msg)
+        return msg
 
-        self.sock.send(msg, 0)
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
+
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
+                if nl_msg.nl_seq in reqs_by_seq:
+                    (op, req_msg, req_flags) = reqs_by_seq[nl_msg.nl_seq]
+                    if nl_msg.extack:
+                        self._decode_extack(req_msg, op, nl_msg.extack)
+                else:
+                    op = self.rsp_by_value[nl_msg.cmd()]
+                    req_flags = []
 
                 if nl_msg.error:
                     raise NlError(nl_msg)
@@ -974,13 +987,25 @@ class YnlFamily(SpecFamily):
                     if nl_msg.extack:
                         print("Netlink warning:")
                         print(nl_msg)
-                    done = True
+
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
 
                 decoded = self.nlproto.decode(self, nl_msg, op)
 
                 # Check if this is a reply to our request
-                if nl_msg.nl_seq != req_seq or decoded.cmd() != op.rsp_value:
+                if nl_msg.nl_seq not in reqs_by_seq or decoded.cmd() != op.rsp_value:
                     if decoded.cmd() in self.async_msg_ids:
                         self.handle_ntf(decoded)
                         continue
@@ -991,18 +1016,23 @@ class YnlFamily(SpecFamily):
                 rsp_msg = self._decode(decoded.raw_attrs, op.attr_set.name)
                 if op.fixed_header:
                     rsp_msg.update(self._decode_struct(decoded.raw, op.fixed_header))
-                rsp.append(rsp_msg)
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

