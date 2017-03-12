From: Jamal Hadi Salim <jhs@mojatatu.com>
Subject: ANNOUNCE: New talk accepted: TIPC Overlapping Ring Neighbor
 Monitoring Algorithm
Date: Sun, 12 Mar 2017 12:03:18 -0400
Message-ID: <33e99656-80e2-9ba7-0984-01965f5243c0@mojatatu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: tech-committee@netdevconf.org, netfilter-devel@vger.kernel.org,
        Brenda Butler <bjb@mojatatu.com>,
        Stephen Jaworski <jaws@mojatatu.com>,
        netfilter@vger.kernel.org, Heri Muhero <hmuhero@gmail.com>
To: people@netdevconf.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:33218 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755757AbdCLQLN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 12 Mar 2017 12:11:13 -0400
Received: by mail-io0-f194.google.com with SMTP id f84so11296929ioj.0
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Mar 2017 09:11:12 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The tech committee would like to announce a new accepted talk.

Jon Maloy will give a talk on the new TIPC ring neighbor monitoring.

Details are
---------
Title: Overlapping Ring Neighbor Monitoring Algorithm in 1000-node Clusters

In Linux 4.7 we introduced a fundamentally new neighbor monitoring
algorithm to TIPC. This algorithm has several advantages:

- It scales better than full mesh monitoring. CPU load increases by
   sqrt(N) instead of by N, network load by sqrt(N)*N instead of N^2.

- Swift neighbor failure discovery is guaranteed even in the presence
   of a partitioned network, contrary to what regular ring supervision
   algorithms can do.

- It has short and deterministic failure discovery times, contrary
   to the Gossip algorithm.

The algorithm is completely distributed, self-adaptive and employs no
centralized or coordinated state. It scales up to at least 1000 nodes
with a failure discovery time in the order of 1 second. We believe this
algorithm should be useful in large container or VM clusters, as well
as in native systems.

A brief summary of the algorithm:

- Each node sorts all its N known neighbors into a circular list. The
   algorithm for this is the same on all nodes.

- The node identifies the next sqrt(N) nodes downstream from itself in
   the list, -its "monitoring domain", and supervises those actively.

- It distributes a record describing its monitoring domain to all the
   neighbors. A new record is distributed when there is a change, e.g.,
   a lost node, in the local domain.

- When a node outside a node's local domain is lost, it relies on updates
   from the sqrt(N) nodes actively monitoring that node for discovering
   the loss.

- In order to handle failures causing a partitioned network, each node
   also selects a set of nodes outside its own domain to monitor actively.
   Those nodes are selected so that no node is more than two active
   supervision hops away. There will be sqrt(n) such nodes. This
   guarantees that a node will discover loss of indirectly monitored
   nodes in a remote partition within a period marginally longer than
   the detection time for actively monitored nodes.

- Each node will immediately re-calculate a new optimal monitoring
   configuration upon any change in the cluster.
-----


cheers,
jamal
