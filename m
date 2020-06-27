Return-Path: <SRS0=mL34=AI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 135ECC433E0
	for <netfilter-devel@archiver.kernel.org>; Sat, 27 Jun 2020 15:00:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA96F2088E
	for <netfilter-devel@archiver.kernel.org>; Sat, 27 Jun 2020 15:00:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vXDgV6JI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbgF0PAQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 27 Jun 2020 11:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbgF0PAP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 27 Jun 2020 11:00:15 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87348C061794
        for <netfilter-devel@vger.kernel.org>; Sat, 27 Jun 2020 08:00:15 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id q7so63863ljm.1
        for <netfilter-devel@vger.kernel.org>; Sat, 27 Jun 2020 08:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:autocrypt:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=1Sa2D+4f71d7ckewoRcoMugCBbN0bZvB/Tyyxu9ROUc=;
        b=vXDgV6JIEEowpirnAaAV/8vvm/BakQLxvcFAskQ8g5W0k/qnRLaFNDaOz/K1qeGY0C
         GyhLgn2P/xQ9iQhGBDHmbBqNPvYaEOOh60EATWwU3O7puCmtSXCMbmpdi2hDS7EZBkwH
         g1txbqoBUXr/jIBIm3IpreX5I9K/5yUj7a6RnZj16ID5fcTLvrZgB560GJhOfc5GvBOL
         +/6hzF69XRV2vxV0ba21v94hh2atOGJKFOovl9v7MUSNkAmujpOm3WvSvryXrHhuO8JA
         2y8kBP7QBO9dPWZkTjbUcnmyHwolw7DA05RoPoPKRw1fWBIvwm7cKFmPD3n0pIIeycsf
         2epQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:autocrypt:message-id:date
         :user-agent:mime-version:content-language:content-transfer-encoding;
        bh=1Sa2D+4f71d7ckewoRcoMugCBbN0bZvB/Tyyxu9ROUc=;
        b=pJkjKYkVCy/V5LKueSHCX9Q09w2y0fhClyfrzVu5GOH0jN/NpqLjBlWglru60z/nlF
         lVJk4abM/yLBmPmnqkKxjsKMnHwXj8dTSX1xk1NfUKyMN8Ire/pqZIyLJLeJVZD4yaP4
         pa4nQIgyvFAXRIB3qA+NTn/SL36jDSoenmO1iHKBf2XAZoLCjQsGt1nfCxxSOBOXjdXA
         IknmIfU5JoV/OH7UaNQfE05IBNMO2W3MKCGFfB2GO7H4W/jbG0bHDj76H1bs6AwTfeJ8
         PkTDhuCSS66T4KEdPMrJDfYwQ8tSrRPjLB6YN2zfoBvtgmRWANY2DSyPGW8Rwa2YFFwM
         Xk+Q==
X-Gm-Message-State: AOAM530d9jOZerqiggeyyipdtFPg3EKMnGHevamOq3T3wt+BTMFhgcIh
        VODO+80bW8575dsFZET38KS2ZqMm
X-Google-Smtp-Source: ABdhPJxfAC9Lg+Lh7e6ODAuTh39jq5sdddY9CtRjp6MBphkkE5oB11DIQprhrBgSwGSr4L7zFJNkkw==
X-Received: by 2002:a2e:b003:: with SMTP id y3mr4036984ljk.78.1593270013516;
        Sat, 27 Jun 2020 08:00:13 -0700 (PDT)
Received: from ?IPv6:2a00:1370:812d:7752:3103:9df:768d:2252? ([2a00:1370:812d:7752:3103:9df:768d:2252])
        by smtp.gmail.com with ESMTPSA id u19sm620591ljk.0.2020.06.27.08.00.12
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 27 Jun 2020 08:00:12 -0700 (PDT)
To:     netfilter-devel@vger.kernel.org
From:   Andrei Borzenkov <arvidjaar@gmail.com>
Subject: mDNS helper fails to add expectations if host joined 224.0.0.251
 multicast group
Autocrypt: addr=arvidjaar@gmail.com; prefer-encrypt=mutual; keydata=
 LS0tLS1CRUdJTiBQR1AgUFVCTElDIEtFWSBCTE9DSy0tLS0tCgptUUdpQkR4aVJ3d1JCQUMz
 Q045d2R3cFZFcVVHbVNvcUY4dFdWSVQ0UC9iTENTWkxraW5TWjJkcnNibEtwZEc3CngrZ3V4
 d3RzK0xnSThxamYvcTVMYWgxVHdPcXpEdmpIWUoxd2JCYXV4WjAzbkR6U0xVaEQ0TXMxSXNx
 bEl3eVQKTHVtUXM0dmNRZHZMeGpGc0c3MGFEZ2xnVVNCb2d0YUlFc2lZWlhsNFgwajNMOWZW
 c3R1ejQvd1h0d0NnMWNOLwp5di9lQkMwdGtjTTFuc0pYUXJDNUF5OEQvMWFBNXFQdGljTEJw
 bUVCeHFrZjBFTUh1enlyRmxxVncxdFVqWitFCnAyTE1sZW04bWFsUHZmZFpLRVo3MVcxYS9Y
 YlJuOEZFU09wMHRVYTVHd2RvRFhnRXAxQ0pVbitXTHVyUjBLUEQKZjAxRTRqL1BISEFvQUJn
 cnFjT1RjSVZvTnB2MmdOaUJ5U1ZzTkd6RlhUZVkvWWQ2dlFjbGtxakJZT05HTjNyOQpSOGJX
 QS8wWTFqNFhLNjFxam93UmszSXk4c0JnZ00zUG1tTlJVSllncm9lcnBjQXIyYnl6NndUc2Iz
 VTdPelVaCjFMbGdpc2s1UXVtMFJONzdtM0kzN0ZYbEloQ21TRVk3S1pWekdOVzNibHVnTEhj
 ZncvSHVDQjdSMXc1cWlMV0sKSzZlQ1FITCtCWndpVThoWDNkdFRxOWQ3V2hSVzVuc1ZQRWFQ
 cXVkUWZNU2kvVXgxa2JRbVFXNWtjbVY1SUVKdgpjbnBsYm10dmRpQThZWEoyYVdScVlXRnlR
 R2R0WVdsc0xtTnZiVDZJWUFRVEVRSUFJQVVDU1hzNk5RSWJBd1lMCkNRZ0hBd0lFRlFJSUF3
 UVdBZ01CQWg0QkFoZUFBQW9KRUVlaXpMcmFYZmVNTE9ZQW5qNG92cGthK21YTnpJbWUKWUNk
 NUxxVzV0bzhGQUo0dlA0SVcrSWM3ZVlYeENMTTcvem05WU1VVmJyUW5RVzVrY21WNUlFSnZj
 bnBsYm10dgpkaUE4WVhKMmFXUnFZV0Z5UUc1bGQyMWhhV3d1Y25VK2lGNEVFeEVDQUI0RkFr
 SXR5WkFDR3dNR0N3a0lCd01DCkF4VUNBd01XQWdFQ0hnRUNGNEFBQ2drUVI2TE11dHBkOTR4
 ajhnQ2VJbThlK2U0cXhETWpRRXhGYlVMNXdNaWkKWUQwQW9LbUlCUzVIRW9wL1R5UUpkTmc2
 U3Z6VmlQRGR0Q1JCYm1SeVpYa2dRbTl5ZW1WdWEyOTJJRHhoY25acApaR3BoWVhKQWJXRnBi
 QzV5ZFQ2SVhBUVRFUUlBSEFVQ1Bxems4QUliQXdRTEJ3TUNBeFVDQXdNV0FnRUNIZ0VDCkY0
 QUFDZ2tRUjZMTXV0cGQ5NHlEdFFDZ2k5NHJoQXdTMXFqK2ZhampiRE02QmlTN0Irc0FvSi9S
 RG1hN0tyQTEKbkllc2JuS29MY1FMYkpZbHRDUkJibVJ5WldvZ1FtOXljMlZ1YTI5M0lEeGhj
 blpwWkdwaFlYSkFiV0ZwYkM1eQpkVDZJVndRVEVRSUFGd1VDUEdKSERRVUxCd29EQkFNVkF3
 SURGZ0lCQWhlQUFBb0pFRWVpekxyYVhmZU1pcFlBCm9MblllRUJmOGNvV2lud3hUZThEVjBS
 T2J4N1NBS0RFamwzdFFxZEY3MGFQd0lPMmgvM0ZqczJjZnJRbVFXNWsKY21WcElFSnZjbnBs
 Ym10dmRpQThZWEoyYVdScVlXRnlRR2R0WVdsc0xtTnZiVDZJWlFRVEVRSUFKUUliQXdZTApD
 UWdIQXdJR0ZRZ0NDUW9MQkJZQ0F3RUNIZ0VDRjRBRkFsaVdBaVFDR1FFQUNna1FSNkxNdXRw
 ZDk0d0ZHd0NlCk51UW5NRHh2ZS9GbzNFdllJa0FPbit6RTIxY0FuUkNRVFhkMWhUZ2NSSGZw
 QXJFZC9SY2I1K1NjdVFFTkJEeGkKUnlRUUJBQ1F0TUUzM1VIZkZPQ0FwTGtpNGtMRnJJdzE1
 QTVhc3VhMTBqbTVJdCtoeHpJOWpEUjkvYk5FS0RUSwpTY2lIbk03YVJVZ2dMd1R0KzZDWGtN
 eThhbit0VnFHTC9NdkRjNC9SS0tsWnhqMzl4UDd3VlhkdDh5MWNpWTRaCnFxWmYzdG1tU045
 RGxMY1pKSU9UODJEYUpadXZyN1VKN3JMekJGYkFVaDR5UkthTm53QURCd1FBak52TXIvS0IK
 Y0dzVi9VdnhaU20vbWRwdlVQdGN3OXFtYnhDcnFGUW9CNlRtb1o3RjZ3cC9yTDNUa1E1VUVs
 UFJnc0cxMitEawo5R2dSaG5ueFRIQ0ZnTjFxVGlaTlg0WUlGcE5yZDBhdTNXL1hrbzc5TDBj
 NC80OXRlbjVPckZJL3BzeDUzZmhZCnZMWWZrSm5jNjJoOGhpTmVNNmtxWWEveDBCRWRkdTky
 Wkc2SVJnUVlFUUlBQmdVQ1BHSkhKQUFLQ1JCSG9zeTYKMmwzM2pNaGRBSjQ4UDdXRHZLTFFR
 NU1Lbm4yRC9USTMzN3VBL2dDZ241bW52bTRTQmN0YmhhU0JnY2tSbWdTeApmd1E9Cj1nWDEr
 Ci0tLS0tRU5EIFBHUCBQVUJMSUMgS0VZIEJMT0NLLS0tLS0K
Message-ID: <155a851c-e800-cec2-5432-cc82d2f36a45@gmail.com>
Date:   Sat, 27 Jun 2020 18:00:11 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Please Cc me on reply, I am not subscribed to this list.

This is result of troubleshooting of user question "why my printer
management application fails to discover printer via mDNS".

Let's start with no firewall to make sure mDNS works.

bor@tw:~> dig -p 5353 @224.0.0.251 leap15.local +short
169.254.1.76
bor@tw:~>

Start firewall and verify that mDNS stops working

tw:/home/bor # systemctl start firewalld.service
tw:/home/bor # dig -p 5353 @224.0.0.251 leap15.local +short

; <<>> DiG 9.16.4 <<>> -p 5353 @224.0.0.251 leap15.local +short
; (1 server found)
;; global options: +cmd
;; connection timed out; no servers could be reached
tw:/home/bor #

Configure mDNS helper (rules for related packets are already default in
firewalld):

w:/home/bor # nfct add helper mdns inet udp
tw:/home/bor # systemctl start conntrackd.service
tw:/home/bor # nfct list helper
{
	.name = mdns,
	.queuenum = 6,
	.l3protonum = 2,
	.l4protonum = 17,
	.priv_data_len = 0,
	.status = enabled,
};
tw:/home/bor # iptables -t raw -A OUTPUT -m addrtype --dst-type
MULTICAST -p udp --dport 5353 -j CT --helper mdns
tw:/home/bor #

Let's try resolving again

bor@tw:~> dig -p 5353 @224.0.0.251 leap15.local +short
169.254.1.76
bor@tw:~>

And expectations are correctly added

tw:/home/bor # conntrack -E expect
    [NEW] 30 proto=17 src=0.0.0.0 dst=169.254.33.186 sport=5353
dport=38407 mask-src=0.0.0.0 mask-dst=0.0.0.0 sport=65535 dport=65535
master-src=169.254.33.186 master-dst=224.0.0.251 sport=38407 dport=5353
PERMANENT class=0 helper=mdns
^Cconntrack v1.4.6 (conntrack-tools): 1 expectation events have been shown.
tw:/home/bor #

Now try registering interface for mDNS multicast group (exactly what
Avahi does):

tw:/home/bor # ip maddress show dev enp0s5
3:	enp0s5
	link  01:00:5e:00:00:01
	link  33:33:00:00:00:01
	link  33:33:ff:89:87:bc
	inet  224.0.0.1
	inet6 ff02::1:ff89:87bc
	inet6 ff02::1
	inet6 ff01::1
tw:/home/bor #

bor@tw:~> python
Python 2.7.18 (default, Apr 23 2020, 09:27:04) [GCC] on linux2
Type "help", "copyright", "credits" or "license" for more information.
>>> import socket
>>> import struct
>>> s = socket.socket (socket.AF_INET, socket.SOCK_DGRAM)
>>> s.bind (("0.0.0.0", 5353))
>>> req = struct.pack ("=4sl", socket.inet_aton("224.0.0.251"),
socket.INADDR_ANY)
>>> s.setsockopt (socket.SOL_IP, socket.IP_ADD_MEMBERSHIP, req)
>>>

tw:/home/bor # ss -4lunp
State     Recv-Q    Send-Q        Local Address:Port       Peer
Address:Port    Process
UNCONN    0         0                   0.0.0.0:5353
0.0.0.0:*        users:(("python",pid=8420,fd=3))
tw:/home/bor # ip maddress show dev enp0s5
3:	enp0s5
	link  01:00:5e:00:00:01
	link  33:33:00:00:00:01
	link  33:33:ff:89:87:bc
	link  01:00:5e:00:00:fb
	inet  224.0.0.251
	inet  224.0.0.1
	inet6 ff02::1:ff89:87bc
	inet6 ff02::1
	inet6 ff01::1
tw:/home/bor #

Let's try to resolve again

tw:/home/bor # dig -p 5353 @224.0.0.251 leap15.local +short

; <<>> DiG 9.16.4 <<>> -p 5353 @224.0.0.251 leap15.local +short
; (1 server found)
;; global options: +cmd
;; connection timed out; no servers could be reached
tw:/home/bor #

and checking what happens is expectations get deleted immediately

tw:/home/bor # conntrack -E expect
    [NEW] 30 proto=17 src=0.0.0.0 dst=169.254.33.186 sport=5353
dport=56327 mask-src=0.0.0.0 mask-dst=0.0.0.0 sport=65535 dport=65535
master-src=169.254.33.186 master-dst=224.0.0.251 sport=56327 dport=5353
PERMANENT class=0 helper=mdns
[DESTROY] 30 proto=17 src=0.0.0.0 dst=169.254.33.186 sport=5353
dport=56327 mask-src=0.0.0.0 mask-dst=0.0.0.0 sport=65535 dport=65535
master-src=169.254.33.186 master-dst=224.0.0.251 sport=56327 dport=5353
PERMANENT class=0 helper=mdns
    [NEW] 30 proto=17 src=0.0.0.0 dst=169.254.33.186 sport=5353
dport=56327 mask-src=0.0.0.0 mask-dst=0.0.0.0 sport=65535 dport=65535
master-src=169.254.33.186 master-dst=224.0.0.251 sport=56327 dport=5353
PERMANENT class=0 helper=mdns
[DESTROY] 30 proto=17 src=0.0.0.0 dst=169.254.33.186 sport=5353
dport=56327 mask-src=0.0.0.0 mask-dst=0.0.0.0 sport=65535 dport=65535
master-src=169.254.33.186 master-dst=224.0.0.251 sport=56327 dport=5353
PERMANENT class=0 helper=mdns
    [NEW] 30 proto=17 src=0.0.0.0 dst=169.254.33.186 sport=5353
dport=56327 mask-src=0.0.0.0 mask-dst=0.0.0.0 sport=65535 dport=65535
master-src=169.254.33.186 master-dst=224.0.0.251 sport=56327 dport=5353
PERMANENT class=0 helper=mdns
[DESTROY] 30 proto=17 src=0.0.0.0 dst=169.254.33.186 sport=5353
dport=56327 mask-src=0.0.0.0 mask-dst=0.0.0.0 sport=65535 dport=65535
master-src=169.254.33.186 master-dst=224.0.0.251 sport=56327 dport=5353
PERMANENT class=0 helper=mdns
    [NEW] 30 proto=17 src=0.0.0.0 dst=169.254.33.186 sport=5353
dport=56327 mask-src=0.0.0.0 mask-dst=0.0.0.0 sport=65535 dport=65535
master-src=169.254.33.186 master-dst=224.0.0.251 sport=56327 dport=5353
PERMANENT class=0 helper=mdns
[DESTROY] 30 proto=17 src=0.0.0.0 dst=169.254.33.186 sport=5353
dport=56327 mask-src=0.0.0.0 mask-dst=0.0.0.0 sport=65535 dport=65535
master-src=169.254.33.186 master-dst=224.0.0.251 sport=56327 dport=5353
PERMANENT class=0 helper=mdns
^Cconntrack v1.4.6 (conntrack-tools): 8 expectation events have been shown.
tw:/home/bor #

This is real life issue, as lot of distributions have Avahi enabled by
default, Avahi registers multicast group as the first thing so discovery
fails as long as Avahi daemon is running which is default.

bor@tw:~> uname -a
Linux tw.0.2.15 5.7.5-1-default #1 SMP Tue Jun 23 06:00:46 UTC 2020
(a1775d0) x86_64 x86_64 x86_64 GNU/Linux
bor@tw:~>
