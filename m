Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03A72C433E0
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Feb 2021 14:51:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBC3664E76
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Feb 2021 14:51:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbhBUOvf convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 21 Feb 2021 09:51:35 -0500
Received: from p3plsmtp05-02-2.prod.phx3.secureserver.net ([97.74.135.47]:51241
        "EHLO p3plwbeout05-02.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229826AbhBUOvd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 21 Feb 2021 09:51:33 -0500
Received: from p3plgemwbe05-04.prod.phx3.secureserver.net ([97.74.135.4])
        by :WBEOUT: with SMTP
        id Dq4RlDv8RjAUIDq4Rlqmb4; Sun, 21 Feb 2021 07:50:51 -0700
X-CMAE-Analysis: v=2.4 cv=FJXee8ks c=1 sm=1 tr=0 ts=6032734b
 a=glJzh28+BKpTlJ+heJPmag==:117 a=Tb-8IF_VHAgA:10 a=gOoLzYk5U4MA:10
 a=IkcTkHD0fZMA:10 a=qa6Q16uM49sA:10 a=dZvGHyHn3zHPZ22dbOYA:9 a=QEXdDO2ut3YA:10
X-SECURESERVER-ACCT: andy@asjohnson.com
X-SID:  Dq4RlDv8RjAUI
Received: (qmail 6294 invoked by uid 99); 21 Feb 2021 14:50:51 -0000
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
X-Originating-IP: 66.72.221.161
User-Agent: Workspace Webmail 6.12.1
Message-Id: <20210221075050.fcdaf64278890662106b299d41e0899d.756e4ddcc3.wbe@email05.godaddy.com>
From:   <andy@asjohnson.com>
To:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: [PATCH] xtables-addons 3.15 doesn't compile on 32-bit x86
Date:   Sun, 21 Feb 2021 07:50:50 -0700
Mime-Version: 1.0
X-CMAE-Envelope: MS4xfNwRb7fS/dnvL5vTQ7+C51Ap2+53922j6r0h7tudLinQNATLGGogF+jxz20kIp2c9n6YR078xmEVeY+FmWhcMrqZHY8TD64bmZU+TqO6a/c08ULmYIp9
 O0T1alRPmDQD2zrALUP/CnXuk7ezIe+tn7PhEbDoCG5QHMsJSq+3BnGr92u9WcQ3QB0bw/vShsX9pF/KBPsJOmugwqHXy9z80qZ76+9AuuiG1Ivtp8wqGoN7
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Xtables-addons 3.15 doesn't compile with 32-bit x86 kernel:

ERROR: "__divdi3"
[/mnt/sdb1/lamp32-11/build/xtables-addons-3.15/extensions/pknock/xt_pknock.ko]
undefined!
 
Replace long integer division with do_div().

This patch fixes it:

--- extensions/pknock/xt_pknock.c-orig                                  
                                                 
+++ extensions/pknock/xt_pknock.c                                       
                                                 
@@ -335,7 +335,9 @@                                                     
                                                 
 static inline bool                                                     
                                                 
 has_logged_during_this_minute(const struct peer *peer)                 
                                                 
 {                                                                      
                                                 
-       return peer != NULL && peer->login_sec / 60 ==
ktime_get_seconds() / 60;                                          
+       unsigned long x = ktime_get_seconds();                          
                                                 
+       unsigned long y = peer->login_sec;                              
                                                 
+       return peer != NULL && do_div(y, 60) == do_div(x, 60);          
                                                 
 }                                                                      
                                                 
                                                                        
                                                 
 /**                                                                    
                                                 
@@ -709,6 +711,7 @@                                                     
                                                 
        unsigned int hexa_size;                                         
                                                 
        int ret;                                                        
                                                 
        bool fret = false;                                              
                                                 
+       unsigned long x = ktime_get_seconds();                          
                                                 
        unsigned int epoch_min;                                         
                                                 
                                                                        
                                                 
        if (payload_len == 0)                                           
                                                 
@@ -727,7 +730,8 @@                                                     
                                                 
        hexresult = kzalloc(hexa_size, GFP_ATOMIC);                     
                                                 
        if (hexresult == NULL)                                          
                                                 
                return false;                                           
                                                 
-       epoch_min = ktime_get_seconds() / 60;                           
                                                 
+                                                                       
                                                 
+       epoch_min = do_div(x, 60);                                      
                                                 
                                                                        
                                                 
        ret = crypto_shash_setkey(crypto.tfm, secret, secret_len);      
                                                 
        if (ret != 0) {
