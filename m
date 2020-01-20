Return-Path: <SRS0=8tM5=3J=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MALFORMED_FREEMAIL,
	NORMAL_HTTP_TO_IP,NUMERIC_HTTP_ADDR,SPF_HELO_NONE,SPF_PASS,WEIRD_PORT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21025C33CAF
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Jan 2020 02:46:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0E7F20678
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Jan 2020 02:46:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CpmiSpoh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729039AbgATCqQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 19 Jan 2020 21:46:16 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:46603 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729030AbgATCqQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 19 Jan 2020 21:46:16 -0500
Received: by mail-qk1-f193.google.com with SMTP id r14so28724373qke.13
        for <netfilter-devel@vger.kernel.org>; Sun, 19 Jan 2020 18:46:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=user-agent:date:subject:from:to:cc:message-id:thread-topic
         :mime-version:content-transfer-encoding;
        bh=mZsZvW9bgiXpuah7MCBqbkePQjslWCa3vqbNP6pCB/A=;
        b=CpmiSpohtIqhKeLyjFGzn28CWFJnj6Ct3FxYoB69I0AmDpo2j1k6V+pDr0Ipaq/0jC
         R9mkrYocFBvrsDyZxqDh4jbgSoR+udy788esutoekxnx6aM69Qcel2B5CBHseE/8xQ5U
         jXCJNuaDOxVzIQnG7qIdEC82TM0psoVcy4n5Lq3h3NC2DCCAbPghF/WbPjGO0snVg8/f
         IId7uAeMFqkL7k79AVehMb7J4/QZ38x5+n9Uip+1ri06EKe+vK96iT/gBmLRfW8nRpuK
         5fQj8r1ECP8pk06auHJspATGptdZbH74IsTmcOB8XQMFzDYNefWunvDi/DHgyerUysv+
         nMPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:user-agent:date:subject:from:to:cc:message-id
         :thread-topic:mime-version:content-transfer-encoding;
        bh=mZsZvW9bgiXpuah7MCBqbkePQjslWCa3vqbNP6pCB/A=;
        b=TRYMHwjOZ1i2eIsJLN5TcB5mgKJ+0sOn9AXyI6azShZ5XTabyDX4dVQ6G9eI36Me80
         sbNJXzVnnMcMxo1++aW9oB5nWcaZ/vYc4wY/QBxau/B6iVf05I0bH1nxMRmNuXCwGJL0
         0e8Ez9crmSftuR1WD/0iRJT1+XVUBYIPBhw90Bno+1J0C1Vu/sWk6vQALEaCRtDifqjG
         FLXzaH5CV2FFedZmB9PsR8pjCzXYLI8G393dV4K6kuaJNoslGUJg0w895CJadtiATkkN
         Csvav1v5lGtAv7ojcwTwTuJnGfzBhWnnpRcrGezjFkD8gsnufEiP32rgreo2oZOfI9wZ
         dN0A==
X-Gm-Message-State: APjAAAVmpFP+1aHYIZGfdigwPC5HFoOztKfXxxHmKk/H05Egk9EyKgV8
        9XqQlAfO52RS8CQRPsxuzu3r1Wv/
X-Google-Smtp-Source: APXvYqz3jmADk19z88b8ZjgfhcJP+bFL8LfGrxH2LGcu7bWyndnmnzdKJZ9PaYb7rW8r/gOcUcbRkw==
X-Received: by 2002:a05:620a:1379:: with SMTP id d25mr51088838qkl.164.1579488373657;
        Sun, 19 Jan 2020 18:46:13 -0800 (PST)
Received: from [192.168.41.177] (modemcable158.205-200-24.mc.videotron.ca. [24.200.205.158])
        by smtp.gmail.com with ESMTPSA id z3sm16811099qtm.5.2020.01.19.18.46.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 19 Jan 2020 18:46:13 -0800 (PST)
User-Agent: Microsoft-MacOutlook/10.21.0.200113
Date:   Sun, 19 Jan 2020 21:46:11 -0500
Subject: load balancing between two chains
From:   sbezverk <sbezverk@gmail.com>
To:     Phil Sutter <phil@nwl.cc>
CC:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Message-ID: <011F145A-C830-444E-A9AD-DB45178EBF78@gmail.com>
Thread-Topic: load balancing between two chains
Mime-version: 1.0
Content-type: text/plain;
        charset="UTF-8"
Content-transfer-encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello Phil,

While doing some performance test, btw the results are awesome so far, I came across an issue. It is kubernetes environment, there is a Cluster scope service with 2 backends, 2 pods. The rule for this service program a load balancing between 2 chains representing each backend pod.  When I curl the service, only 1 backend pod replies, second times out. If I delete pod which was working, then second pod starts replying to curl requests. Here are some logs and packets captures. Appreciate if you could take a look at it and share your thoughts.

Thank you
Serguei

!
! Service chain port TCP 808 is exposed port
!
        chain k8s-nfproxy-svc-M53CN2XYVUHRQ7UB {
                numgen random mod 2 vmap { 0 : jump k8s-nfproxy-sep-RGU2UYFOJNW24NA5, 1 : jump k8s-nfproxy-sep-I7XZOUOVPIQW4IXA } comment ""
        }
!
!  backend pod 1 listens on port 8080
!
        chain k8s-nfproxy-sep-RGU2UYFOJNW24NA5 {
                ip saddr 57.112.0.35 meta mark set 0x00004000
                dnat to 57.112.0.35:8080 fully-random comment "I"
        }
!
! backend pod 2 listens on port 8989
!
        chain k8s-nfproxy-sep-I7XZOUOVPIQW4IXA {
                ip saddr 57.112.0.36 meta mark set 0x00004000
                dnat to 57.112.0.36:8989 fully-random comment "I"
        }

sbezverk@kube-4:~/pods/nftables$ kubectl get svc
NAME                        TYPE        CLUSTER-IP      EXTERNAL-IP      PORT(S)           AGE
app2                        ClusterIP   57.141.53.140   192.168.80.104   808/TCP,809/UDP   12h


sbezverk@kube-4:~/pods/nftables$ curl http://192.168.80.104:808
Still alive pod1 :)

sbezverk@kube-4:~/pods/nftables$ curl http://192.168.80.104:808
curl: (7) Failed to connect to 192.168.80.104 port 808: Connection refused

sbezverk@kube-4:~/pods/nftables$ curl http://192.168.80.104:808
Still alive pod1 :)

sbezverk@kube-4:~/pods/nftables$ curl http://192.168.80.104:808
curl: (7) Failed to connect to 192.168.80.104 port 808: Connection refused

sbezverk@kube-4:~/pods/nftables$ kubectl get pods
NAME                                    READY   STATUS    RESTARTS   AGE
app2-backend-1-57df95db4d-5n9sz         2/2     Running   0          7h2m
app2-backend-2-5b9c9b7b6f-8zppz         2/2     Running   0          6h46m

!
! As you can see each pod is listening on corresponding container ports
!
sbezverk@kube-4:~/pods/nftables$ kubectl exec app2-backend-1-57df95db4d-5n9sz -- netstat -tunlp
Defaulting container name to nft.
Use 'kubectl describe pod/app2-backend-1-57df95db4d-5n9sz -n default' to see all of the containers in this pod.
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
tcp        0      0 0.0.0.0:8080            0.0.0.0:*               LISTEN      40/nc               
tcp        0      0 0.0.0.0:5555            0.0.0.0:*               LISTEN      -                   
tcp6       0      0 :::8080                 :::*                    LISTEN      40/nc               
tcp6       0      0 :::5555                 :::*                    LISTEN      -                   

sbezverk@kube-4:~/pods/nftables$ kubectl exec app2-backend-2-5b9c9b7b6f-8zppz -- netstat -tunlp
Defaulting container name to nft.
Use 'kubectl describe pod/app2-backend-2-5b9c9b7b6f-8zppz -n default' to see all of the containers in this pod.
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
tcp        0      0 0.0.0.0:8989            0.0.0.0:*               LISTEN      9/nc                
tcp        0      0 0.0.0.0:6666            0.0.0.0:*               LISTEN      -                   
tcp6       0      0 :::8989                 :::*                    LISTEN      9/nc                
tcp6       0      0 :::6666                 :::*                    LISTEN      -                   



sbezverk@kube-4:~/pods/nftables$ curl http://57.141.53.140:808
Still alive pod1 :)
sbezverk@kube-4:~/pods/nftables$ curl http://57.141.53.140:808
^C
sbezverk@kube-4:~/pods/nftables$



[root@app2-backend-1-57df95db4d-5n9sz /]# tcpdump -i eth0 -v -x -nnnn
tcpdump: listening on eth0, link-type EN10MB (Ethernet), capture size 262144 bytes

01:46:08.015618 IP (tos 0x0, ttl 64, id 15032, offset 0, flags [DF], proto TCP (6), length 60)
    192.168.80.104.24259 > 57.112.0.35.8080: Flags [S], cksum 0x4ad2 (incorrect -> 0x6541), seq 995259474, win 65495, options [mss 65495,sackOK,TS val 2275469446 ecr 0,nop,wscale 7], length 0
        0x0000:  4500 003c 3ab8 4000 4006 b560 c0a8 5068
        0x0010:  3970 0023 5ec3 1f90 3b52 7452 0000 0000
        0x0020:  a002 ffd7 4ad2 0000 0204 ffd7 0402 080a
        0x0030:  87a0 e886 0000 0000 0103 0307
01:46:08.015635 IP (tos 0x0, ttl 64, id 0, offset 0, flags [DF], proto TCP (6), length 60)
    57.112.0.35.8080 > 192.168.80.104.24259: Flags [S.], cksum 0x4ad2 (incorrect -> 0xc783), seq 2583386211, ack 995259475, win 65160, options [mss 1460,sackOK,TS val 1202282263 ecr 2275469446,nop,wscale 7], length 0
        0x0000:  4500 003c 0000 4000 4006 f018 3970 0023
        0x0010:  c0a8 5068 1f90 5ec3 99fb 5863 3b52 7453
        0x0020:  a012 fe88 4ad2 0000 0204 05b4 0402 080a
        0x0030:  47a9 5f17 87a0 e886 0103 0307
01:46:08.015652 IP (tos 0x0, ttl 64, id 15033, offset 0, flags [DF], proto TCP (6), length 52)
    192.168.80.104.24259 > 57.112.0.35.8080: Flags [.], cksum 0x4aca (incorrect -> 0xf2d8), ack 1, win 512, options [nop,nop,TS val 2275469446 ecr 1202282263], length 0
        0x0000:  4500 0034 3ab9 4000 4006 b567 c0a8 5068
        0x0010:  3970 0023 5ec3 1f90 3b52 7453 99fb 5864
        0x0020:  8010 0200 4aca 0000 0101 080a 87a0 e886
        0x0030:  47a9 5f17
01:46:08.015700 IP (tos 0x0, ttl 64, id 15034, offset 0, flags [DF], proto TCP (6), length 134)
    192.168.80.104.24259 > 57.112.0.35.8080: Flags [P.], cksum 0x4b1c (incorrect -> 0x0ba6), seq 1:83, ack 1, win 512, options [nop,nop,TS val 2275469446 ecr 1202282263], length 82: HTTP, length: 82
        GET / HTTP/1.1
        Host: 192.168.80.104:808
        User-Agent: curl/7.58.0
        Accept: */*

        0x0000:  4500 0086 3aba 4000 4006 b514 c0a8 5068
        0x0010:  3970 0023 5ec3 1f90 3b52 7453 99fb 5864
        0x0020:  8018 0200 4b1c 0000 0101 080a 87a0 e886
        0x0030:  47a9 5f17 4745 5420 2f20 4854 5450 2f31
        0x0040:  2e31 0d0a 486f 7374 3a20 3139 322e 3136
        0x0050:  382e 3830 2e31 3034 3a38 3038 0d0a 5573
        0x0060:  6572 2d41 6765 6e74 3a20 6375 726c 2f37
        0x0070:  2e35 382e 300d 0a41 6363 6570 743a 202a
        0x0080:  2f2a 0d0a 0d0a
01:46:08.015704 IP (tos 0x0, ttl 64, id 5774, offset 0, flags [DF], proto TCP (6), length 52)
    57.112.0.35.8080 > 192.168.80.104.24259: Flags [.], cksum 0x4aca (incorrect -> 0xf289), ack 83, win 509, options [nop,nop,TS val 1202282263 ecr 2275469446], length 0
        0x0000:  4500 0034 168e 4000 4006 d992 3970 0023
        0x0010:  c0a8 5068 1f90 5ec3 99fb 5864 3b52 74a5
        0x0020:  8010 01fd 4aca 0000 0101 080a 47a9 5f17
        0x0030:  87a0 e886
01:46:08.015784 IP (tos 0x0, ttl 64, id 5775, offset 0, flags [DF], proto TCP (6), length 89)
    57.112.0.35.8080 > 192.168.80.104.24259: Flags [P.], cksum 0x4aef (incorrect -> 0x2924), seq 1:38, ack 83, win 509, options [nop,nop,TS val 1202282263 ecr 2275469446], length 37: HTTP, length: 37
        HTTP/1.0 200 Ok

        Still alive pod1 :)
        0x0000:  4500 0059 168f 4000 4006 d96c 3970 0023
        0x0010:  c0a8 5068 1f90 5ec3 99fb 5864 3b52 74a5
        0x0020:  8018 01fd 4aef 0000 0101 080a 47a9 5f17
        0x0030:  87a0 e886 4854 5450 2f31 2e30 2032 3030
        0x0040:  204f 6b0a 0a53 7469 6c6c 2061 6c69 7665
        0x0050:  2070 6f64 3120 3a29 0a
01:46:08.015808 IP (tos 0x0, ttl 64, id 15035, offset 0, flags [DF], proto TCP (6), length 52)
    192.168.80.104.24259 > 57.112.0.35.8080: Flags [.], cksum 0x4aca (incorrect -> 0xf261), ack 38, win 512, options [nop,nop,TS val 2275469446 ecr 1202282263], length 0
        0x0000:  4500 0034 3abb 4000 4006 b565 c0a8 5068
        0x0010:  3970 0023 5ec3 1f90 3b52 74a5 99fb 5889
        0x0020:  8010 0200 4aca 0000 0101 080a 87a0 e886
        0x0030:  47a9 5f17
01:46:08.015877 IP (tos 0x0, ttl 64, id 5776, offset 0, flags [DF], proto TCP (6), length 52)
    57.112.0.35.8080 > 192.168.80.104.24259: Flags [F.], cksum 0x4aca (incorrect -> 0xf263), seq 38, ack 83, win 509, options [nop,nop,TS val 1202282263 ecr 2275469446], length 0
        0x0000:  4500 0034 1690 4000 4006 d990 3970 0023
        0x0010:  c0a8 5068 1f90 5ec3 99fb 5889 3b52 74a5
        0x0020:  8011 01fd 4aca 0000 0101 080a 47a9 5f17
        0x0030:  87a0 e886
01:46:08.016107 IP (tos 0x0, ttl 64, id 15036, offset 0, flags [DF], proto TCP (6), length 52)
    192.168.80.104.24259 > 57.112.0.35.8080: Flags [F.], cksum 0x4aca (incorrect -> 0xf25f), seq 83, ack 39, win 512, options [nop,nop,TS val 2275469446 ecr 1202282263], length 0
        0x0000:  4500 0034 3abc 4000 4006 b564 c0a8 5068
        0x0010:  3970 0023 5ec3 1f90 3b52 74a5 99fb 588a
        0x0020:  8011 0200 4aca 0000 0101 080a 87a0 e886
        0x0030:  47a9 5f17
01:46:08.016119 IP (tos 0x0, ttl 64, id 5777, offset 0, flags [DF], proto TCP (6), length 52)
    57.112.0.35.8080 > 192.168.80.104.24259: Flags [.], cksum 0x4aca (incorrect -> 0xf262), ack 84, win 509, options [nop,nop,TS val 1202282263 ecr 2275469446], length 0
        0x0000:  4500 0034 1691 4000 4006 d98f 3970 0023
        0x0010:  c0a8 5068 1f90 5ec3 99fb 588a 3b52 74a6
        0x0020:  8010 01fd 4aca 0000 0101 080a 47a9 5f17
        0x0030:  87a0 e886
01:46:13.222944 ARP, Ethernet (len 6), IPv4 (len 4), Request who-has 169.254.1.1 tell 57.112.0.35, length 28
        0x0000:  0001 0800 0604 0001 8ad7 3650 134c 3970
        0x0010:  0023 0000 0000 0000 a9fe 0101
01:46:13.222989 ARP, Ethernet (len 6), IPv4 (len 4), Request who-has 57.112.0.35 tell 192.168.80.104, length 28
        0x0000:  0001 0800 0604 0001 eeee eeee eeee c0a8
        0x0010:  5068 0000 0000 0000 3970 0023
01:46:13.222992 ARP, Ethernet (len 6), IPv4 (len 4), Reply 57.112.0.35 is-at 8a:d7:36:50:13:4c, length 28
        0x0000:  0001 0800 0604 0002 8ad7 3650 134c 3970
        0x0010:  0023 eeee eeee eeee c0a8 5068
01:46:13.223010 ARP, Ethernet (len 6), IPv4 (len 4), Reply 169.254.1.1 is-at ee:ee:ee:ee:ee:ee, length 28
        0x0000:  0001 0800 0604 0002 eeee eeee eeee a9fe
        0x0010:  0101 8ad7 3650 134c 3970 0023


sbezverk@kube-4:~/pods/nftables$ kubectl delete -f pod-app2.yaml 
deployment.apps "app2-backend-1" deleted
sbezverk@kube-4:~/pods/nftables$ curl http://57.141.53.140:808
Still alive from pod2 :)
sbezverk@kube-4:~/pods/nftables$ curl http://192.168.80.104:808
Still alive from pod2 :)

[root@app2-backend-2-5b9c9b7b6f-8zppz /]# tcpdump -i eth0 -v -x -nnn
tcpdump: listening on eth0, link-type EN10MB (Ethernet), capture size 262144 bytes

01:47:24.603281 IP (tos 0x0, ttl 64, id 3490, offset 0, flags [DF], proto TCP (6), length 60)
    192.168.80.104.29974 > 57.112.0.36.8989: Flags [S], cksum 0x4ad3 (incorrect -> 0x5f6b), seq 3208549399, win 64240, options [mss 1460,sackOK,TS val 1264020510 ecr 0,nop,wscale 7], length 0
        0x0000:  4500 003c 0da2 4000 4006 e275 c0a8 5068
        0x0010:  3970 0024 7516 231d bf3e 9417 0000 0000
        0x0020:  a002 faf0 4ad3 0000 0204 05b4 0402 080a
        0x0030:  4b57 6c1e 0000 0000 0103 0307
01:47:24.603310 IP (tos 0x0, ttl 64, id 0, offset 0, flags [DF], proto TCP (6), length 60)
    57.112.0.36.8989 > 192.168.80.104.29974: Flags [S.], cksum 0x4ad3 (incorrect -> 0x0fd1), seq 2648221851, ack 3208549400, win 65160, options [mss 1460,sackOK,TS val 911265580 ecr 1264020510,nop,wscale 7], length 0
        0x0000:  4500 003c 0000 4000 4006 f017 3970 0024
        0x0010:  c0a8 5068 231d 7516 9dd8 a89b bf3e 9418
        0x0020:  a012 fe88 4ad3 0000 0204 05b4 0402 080a
        0x0030:  3650 cf2c 4b57 6c1e 0103 0307
01:47:24.603338 IP (tos 0x0, ttl 64, id 3491, offset 0, flags [DF], proto TCP (6), length 52)
    192.168.80.104.29974 > 57.112.0.36.8989: Flags [.], cksum 0x4acb (incorrect -> 0x3b30), ack 1, win 502, options [nop,nop,TS val 1264020510 ecr 911265580], length 0
        0x0000:  4500 0034 0da3 4000 4006 e27c c0a8 5068
        0x0010:  3970 0024 7516 231d bf3e 9418 9dd8 a89c
        0x0020:  8010 01f6 4acb 0000 0101 080a 4b57 6c1e
        0x0030:  3650 cf2c
01:47:24.603387 IP (tos 0x0, ttl 64, id 3492, offset 0, flags [DF], proto TCP (6), length 133)
    192.168.80.104.29974 > 57.112.0.36.8989: Flags [P.], cksum 0x4b1c (incorrect -> 0x3c4e), seq 1:82, ack 1, win 502, options [nop,nop,TS val 1264020511 ecr 911265580], length 81
        0x0000:  4500 0085 0da4 4000 4006 e22a c0a8 5068
        0x0010:  3970 0024 7516 231d bf3e 9418 9dd8 a89c
        0x0020:  8018 01f6 4b1c 0000 0101 080a 4b57 6c1f
        0x0030:  3650 cf2c 4745 5420 2f20 4854 5450 2f31
        0x0040:  2e31 0d0a 486f 7374 3a20 3537 2e31 3431
        0x0050:  2e35 332e 3134 303a 3830 380d 0a55 7365
        0x0060:  722d 4167 656e 743a 2063 7572 6c2f 372e
        0x0070:  3538 2e30 0d0a 4163 6365 7074 3a20 2a2f
        0x0080:  2a0d 0a0d 0a
01:47:24.603391 IP (tos 0x0, ttl 64, id 12585, offset 0, flags [DF], proto TCP (6), length 52)
    57.112.0.36.8989 > 192.168.80.104.29974: Flags [.], cksum 0x4acb (incorrect -> 0x3ad6), ack 82, win 509, options [nop,nop,TS val 911265581 ecr 1264020511], length 0
        0x0000:  4500 0034 3129 4000 4006 bef6 3970 0024
        0x0010:  c0a8 5068 231d 7516 9dd8 a89c bf3e 9469
        0x0020:  8010 01fd 4acb 0000 0101 080a 3650 cf2d
        0x0030:  4b57 6c1f
01:47:24.603419 IP (tos 0x0, ttl 64, id 12586, offset 0, flags [DF], proto TCP (6), length 94)
    57.112.0.36.8989 > 192.168.80.104.29974: Flags [P.], cksum 0x4af5 (incorrect -> 0x58ad), seq 1:43, ack 82, win 509, options [nop,nop,TS val 911265581 ecr 1264020511], length 42
        0x0000:  4500 005e 312a 4000 4006 becb 3970 0024
        0x0010:  c0a8 5068 231d 7516 9dd8 a89c bf3e 9469
        0x0020:  8018 01fd 4af5 0000 0101 080a 3650 cf2d
        0x0030:  4b57 6c1f 4854 5450 2f31 2e30 2032 3030
        0x0040:  204f 6b0a 0a53 7469 6c6c 2061 6c69 7665
        0x0050:  2066 726f 6d20 706f 6432 203a 290a
01:47:24.603498 IP (tos 0x0, ttl 64, id 3493, offset 0, flags [DF], proto TCP (6), length 52)
    192.168.80.104.29974 > 57.112.0.36.8989: Flags [.], cksum 0x4acb (incorrect -> 0x3ab3), ack 43, win 502, options [nop,nop,TS val 1264020511 ecr 911265581], length 0
        0x0000:  4500 0034 0da5 4000 4006 e27a c0a8 5068
        0x0010:  3970 0024 7516 231d bf3e 9469 9dd8 a8c6
        0x0020:  8010 01f6 4acb 0000 0101 080a 4b57 6c1f
        0x0030:  3650 cf2d
01:47:24.603553 IP (tos 0x0, ttl 64, id 12587, offset 0, flags [DF], proto TCP (6), length 52)
    57.112.0.36.8989 > 192.168.80.104.29974: Flags [F.], cksum 0x4acb (incorrect -> 0x3aab), seq 43, ack 82, win 509, options [nop,nop,TS val 911265581 ecr 1264020511], length 0
        0x0000:  4500 0034 312b 4000 4006 bef4 3970 0024
        0x0010:  c0a8 5068 231d 7516 9dd8 a8c6 bf3e 9469
        0x0020:  8011 01fd 4acb 0000 0101 080a 3650 cf2d
        0x0030:  4b57 6c1f
01:47:24.603607 IP (tos 0x0, ttl 64, id 3494, offset 0, flags [DF], proto TCP (6), length 52)
    192.168.80.104.29974 > 57.112.0.36.8989: Flags [F.], cksum 0x4acb (incorrect -> 0x3ab1), seq 82, ack 44, win 502, options [nop,nop,TS val 1264020511 ecr 911265581], length 0
        0x0000:  4500 0034 0da6 4000 4006 e279 c0a8 5068
        0x0010:  3970 0024 7516 231d bf3e 9469 9dd8 a8c7
        0x0020:  8011 01f6 4acb 0000 0101 080a 4b57 6c1f
        0x0030:  3650 cf2d
01:47:24.603616 IP (tos 0x0, ttl 64, id 12588, offset 0, flags [DF], proto TCP (6), length 52)
    57.112.0.36.8989 > 192.168.80.104.29974: Flags [.], cksum 0x4acb (incorrect -> 0x3aaa), ack 83, win 509, options [nop,nop,TS val 911265581 ecr 1264020511], length 0
        0x0000:  4500 0034 312c 4000 4006 bef3 3970 0024
        0x0010:  c0a8 5068 231d 7516 9dd8 a8c7 bf3e 946a
        0x0020:  8010 01fd 4acb 0000 0101 080a 3650 cf2d
        0x0030:  4b57 6c1f
01:47:29.766863 ARP, Ethernet (len 6), IPv4 (len 4), Request who-has 169.254.1.1 tell 57.112.0.36, length 28
        0x0000:  0001 0800 0604 0001 3e10 5d99 078e 3970
        0x0010:  0024 0000 0000 0000 a9fe 0101
01:47:29.766939 ARP, Ethernet (len 6), IPv4 (len 4), Request who-has 57.112.0.36 tell 192.168.80.104, length 28
        0x0000:  0001 0800 0604 0001 eeee eeee eeee c0a8
        0x0010:  5068 0000 0000 0000 3970 0024
01:47:29.766943 ARP, Ethernet (len 6), IPv4 (len 4), Reply 57.112.0.36 is-at 3e:10:5d:99:07:8e, length 28
        0x0000:  0001 0800 0604 0002 3e10 5d99 078e 3970
        0x0010:  0024 eeee eeee eeee c0a8 5068
01:47:29.766962 ARP, Ethernet (len 6), IPv4 (len 4), Reply 169.254.1.1 is-at ee:ee:ee:ee:ee:ee, length 28
        0x0000:  0001 0800 0604 0002 eeee eeee eeee a9fe
        0x0010:  0101 3e10 5d99 078e 3970 0024
01:47:46.295822 IP (tos 0x0, ttl 64, id 9839, offset 0, flags [DF], proto TCP (6), length 60)
    192.168.80.104.44286 > 57.112.0.36.8989: Flags [S], cksum 0x4ad3 (incorrect -> 0x65ba), seq 1424853131, win 65495, options [mss 65495,sackOK,TS val 2275567726 ecr 0,nop,wscale 7], length 0
        0x0000:  4500 003c 266f 4000 4006 c9a8 c0a8 5068
        0x0010:  3970 0024 acfe 231d 54ed 888b 0000 0000
        0x0020:  a002 ffd7 4ad3 0000 0204 ffd7 0402 080a
        0x0030:  87a2 686e 0000 0000 0103 0307
01:47:46.295841 IP (tos 0x0, ttl 64, id 0, offset 0, flags [DF], proto TCP (6), length 60)
    57.112.0.36.8989 > 192.168.80.104.44286: Flags [S.], cksum 0x4ad3 (incorrect -> 0x6349), seq 2661811440, ack 1424853132, win 65160, options [mss 1460,sackOK,TS val 911287273 ecr 2275567726,nop,wscale 7], length 0
        0x0000:  4500 003c 0000 4000 4006 f017 3970 0024
        0x0010:  c0a8 5068 231d acfe 9ea8 04f0 54ed 888c
        0x0020:  a012 fe88 4ad3 0000 0204 05b4 0402 080a
        0x0030:  3651 23e9 87a2 686e 0103 0307
01:47:46.295859 IP (tos 0x0, ttl 64, id 9840, offset 0, flags [DF], proto TCP (6), length 52)
    192.168.80.104.44286 > 57.112.0.36.8989: Flags [.], cksum 0x4acb (incorrect -> 0x8e9e), ack 1, win 512, options [nop,nop,TS val 2275567726 ecr 911287273], length 0
        0x0000:  4500 0034 2670 4000 4006 c9af c0a8 5068
        0x0010:  3970 0024 acfe 231d 54ed 888c 9ea8 04f1
        0x0020:  8010 0200 4acb 0000 0101 080a 87a2 686e
        0x0030:  3651 23e9
01:47:46.295948 IP (tos 0x0, ttl 64, id 9841, offset 0, flags [DF], proto TCP (6), length 134)
    192.168.80.104.44286 > 57.112.0.36.8989: Flags [P.], cksum 0x4b1d (incorrect -> 0xa76b), seq 1:83, ack 1, win 512, options [nop,nop,TS val 2275567726 ecr 911287273], length 82
        0x0000:  4500 0086 2671 4000 4006 c95c c0a8 5068
        0x0010:  3970 0024 acfe 231d 54ed 888c 9ea8 04f1
        0x0020:  8018 0200 4b1d 0000 0101 080a 87a2 686e
        0x0030:  3651 23e9 4745 5420 2f20 4854 5450 2f31
        0x0040:  2e31 0d0a 486f 7374 3a20 3139 322e 3136
        0x0050:  382e 3830 2e31 3034 3a38 3038 0d0a 5573
        0x0060:  6572 2d41 6765 6e74 3a20 6375 726c 2f37
        0x0070:  2e35 382e 300d 0a41 6363 6570 743a 202a
        0x0080:  2f2a 0d0a 0d0a
01:47:46.295952 IP (tos 0x0, ttl 64, id 43541, offset 0, flags [DF], proto TCP (6), length 52)
    57.112.0.36.8989 > 192.168.80.104.44286: Flags [.], cksum 0x4acb (incorrect -> 0x8e4f), ack 83, win 509, options [nop,nop,TS val 911287273 ecr 2275567726], length 0
        0x0000:  4500 0034 aa15 4000 4006 460a 3970 0024
        0x0010:  c0a8 5068 231d acfe 9ea8 04f1 54ed 88de
        0x0020:  8010 01fd 4acb 0000 0101 080a 3651 23e9
        0x0030:  87a2 686e
01:47:46.296030 IP (tos 0x0, ttl 64, id 43542, offset 0, flags [DF], proto TCP (6), length 94)
    57.112.0.36.8989 > 192.168.80.104.44286: Flags [P.], cksum 0x4af5 (incorrect -> 0xac26), seq 1:43, ack 83, win 509, options [nop,nop,TS val 911287273 ecr 2275567726], length 42
        0x0000:  4500 005e aa16 4000 4006 45df 3970 0024
        0x0010:  c0a8 5068 231d acfe 9ea8 04f1 54ed 88de
        0x0020:  8018 01fd 4af5 0000 0101 080a 3651 23e9
        0x0030:  87a2 686e 4854 5450 2f31 2e30 2032 3030
        0x0040:  204f 6b0a 0a53 7469 6c6c 2061 6c69 7665
        0x0050:  2066 726f 6d20 706f 6432 203a 290a
01:47:46.296070 IP (tos 0x0, ttl 64, id 9842, offset 0, flags [DF], proto TCP (6), length 52)
    192.168.80.104.44286 > 57.112.0.36.8989: Flags [.], cksum 0x4acb (incorrect -> 0x8e22), ack 43, win 512, options [nop,nop,TS val 2275567726 ecr 911287273], length 0
        0x0000:  4500 0034 2672 4000 4006 c9ad c0a8 5068
        0x0010:  3970 0024 acfe 231d 54ed 88de 9ea8 051b
        0x0020:  8010 0200 4acb 0000 0101 080a 87a2 686e
        0x0030:  3651 23e9
01:47:46.296113 IP (tos 0x0, ttl 64, id 43543, offset 0, flags [DF], proto TCP (6), length 52)
    57.112.0.36.8989 > 192.168.80.104.44286: Flags [F.], cksum 0x4acb (incorrect -> 0x8e24), seq 43, ack 83, win 509, options [nop,nop,TS val 911287273 ecr 2275567726], length 0
        0x0000:  4500 0034 aa17 4000 4006 4608 3970 0024
        0x0010:  c0a8 5068 231d acfe 9ea8 051b 54ed 88de
        0x0020:  8011 01fd 4acb 0000 0101 080a 3651 23e9
        0x0030:  87a2 686e
01:47:46.296186 IP (tos 0x0, ttl 64, id 9843, offset 0, flags [DF], proto TCP (6), length 52)
    192.168.80.104.44286 > 57.112.0.36.8989: Flags [F.], cksum 0x4acb (incorrect -> 0x8e20), seq 83, ack 44, win 512, options [nop,nop,TS val 2275567726 ecr 911287273], length 0
        0x0000:  4500 0034 2673 4000 4006 c9ac c0a8 5068
        0x0010:  3970 0024 acfe 231d 54ed 88de 9ea8 051c
        0x0020:  8011 0200 4acb 0000 0101 080a 87a2 686e
        0x0030:  3651 23e9
01:47:46.296199 IP (tos 0x0, ttl 64, id 43544, offset 0, flags [DF], proto TCP (6), length 52)
    57.112.0.36.8989 > 192.168.80.104.44286: Flags [.], cksum 0x4acb (incorrect -> 0x8e23), ack 84, win 509, options [nop,nop,TS val 911287273 ecr 2275567726], length 0
        0x0000:  4500 0034 aa18 4000 4006 4607 3970 0024
        0x0010:  c0a8 5068 231d acfe 9ea8 051c 54ed 88df
        0x0020:  8010 01fd 4acb 0000 0101 080a 3651 23e9
        0x0030:  87a2 686e

sbezverk@kube-4:~/pods/nftables$ kubectl get pods
NAME                                    READY   STATUS    RESTARTS   AGE
app2-backend-1-57df95db4d-wvgrk         2/2     Running   0          39s
app2-backend-2-5b9c9b7b6f-8zppz         2/2     Running   0          6h59m
icmp-responder-nsc-69c7bc4f84-9kwsj     3/3     Running   0          3d22h
icmp-responder-nse-75868d8cdc-vgtl5     1/1     Running   0          3d22h
nsm-admission-webhook-b947766c8-rjjl4   1/1     Running   0          3d23h
nsm-vpp-forwarder-c5z44                 1/1     Running   0          3d23h
nsmgr-znh86                             3/3     Running   1          5h17m
prefix-service-58dcbd95d6-pd7g7         1/1     Running   0          3d23h
sbezverk@kube-4:~/pods/nftables$ curl http://192.168.80.104:808
Still alive from pod2 :)
sbezverk@kube-4:~/pods/nftables$ curl http://192.168.80.104:808
curl: (7) Failed to connect to 192.168.80.104 port 808: Connection refused
sbezverk@kube-4:~/pods/nftables$ curl http://57.141.53.140:808
Still alive from pod2 :)
sbezverk@kube-4:~/pods/nftables$ curl http://57.141.53.140:808

curl: (7) Failed to connect to 57.141.53.140 port 808: Connection timed out


