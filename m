From: BORBELY Zoltan <bozo@andrews.hu>
Subject: Re: crash in death_by_timeout()
Date: Tue, 18 Nov 2008 13:38:30 +0100
Message-ID: <20081118123830.GD3201@zebra.home>
References: <20081117221855.GD3271@zebra.home> <4922A1E8.7080405@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="76DTJ5CE0DCVQemd"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx6.datanet.hu ([194.149.13.165]:52138 "EHLO mx6.datanet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084AbYKRMix (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Nov 2008 07:38:53 -0500
Received: from dolphin (tng660dvmi.adsl.datanet.hu [195.56.206.203])
	by mx6.datanet.hu (DataNet) with ESMTP id CAD4D130D19
	for <netfilter-devel@vger.kernel.org>; Tue, 18 Nov 2008 13:38:50 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <4922A1E8.7080405@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--76DTJ5CE0DCVQemd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On Tue, Nov 18, 2008 at 12:07:20PM +0100, Patrick McHardy wrote:
>> --- /tmp/nf_conntrack_netlink.c-orig	2008-09-29 23:28:55.000000000 +0200
>> +++ /tmp/nf_conntrack_netlink.c	2008-09-29 23:29:11.000000000 +0200
>> @@ -1177,8 +1177,8 @@
>>  		ct->master = master_ct;
>>  	}
>>  -	add_timer(&ct->timeout);
>>  	nf_conntrack_hash_insert(ct);
>> +	add_timer(&ct->timeout);
>>  	rcu_read_unlock();
>
> That code looks very fishy. We should be holding the conntrack lock,
> otherwise the addition is not only racy against the timer, but also
> against addition of identical conntracks. Let me look into what
> happened here.

We have experienced a lot of kernel crashes, _every time_ in the
death_by_timeout() function while we were trying to add a new conntrack
entry from userspace via netlink (attached the disassembled version
of the function, ===> points to the EIP upon the crash). There was a
possibility, that we tried to add conntrack entries with zero timeout
value, maybe it's necessary to trigger this crash. The previous patch
has definitly solved the problem for us.

I've got photos from various crashes, but it takes a little time to
find them. Please let me know if you want to see them.

Thanks,
Zoltan Borbely

--76DTJ5CE0DCVQemd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="2.6.26.3-death_by_timeout.txt"

00000350 <death_by_timeout>:
     350:	55                   	push   %ebp
     351:	89 e5                	mov    %esp,%ebp
     353:	56                   	push   %esi
     354:	53                   	push   %ebx
     355:	89 c3                	mov    %eax,%ebx
     357:	83 ec 0c             	sub    $0xc,%esp

     35a:	8b 90 cc 00 00 00    	mov    0xcc(%eax),%edx
     360:	85 d2                	test   %edx,%edx
     362:	74 08                	je     36c <death_by_timeout+0x1c>
     364:	0f b6 42 08          	movzbl 0x8(%edx),%eax
     368:	84 c0                	test   %al,%al
     36a:	75 74                	jne    3e0 <death_by_timeout+0x90>

     36c:	b8 00 00 00 00       	mov    <nf_conntrack_lock>,%eax
     371:	e8 fc ff ff ff       	call   <_spin_lock_bh>

     376:	8d 4b 04             	lea    0x4(%ebx),%ecx
     379:	ff 05 18 00 00 00    	incl   <per_cpu__nf_conntrack_stat>

     					// hlist_del_rcu(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnode)
     37f:	8b 43 04             	mov    0x4(%ebx),%eax
     382:	8b 51 04             	mov    0x4(%ecx),%edx
     385:	85 c0                	test   %eax,%eax
===> 387:	89 02                	mov    %eax,(%edx)
     389:	74 03                	je     38e <death_by_timeout+0x3e>
     38b:	89 50 04             	mov    %edx,0x4(%eax)
     38e:	c7 41 04 00 02 20 00 	movl   $0x200200,0x4(%ecx)	// LIST_POISON2

     					// hlist_del_rcu(&ct->tuplehash[IP_CT_DIR_REPLY].hnode)
     395:	8b 43 34             	mov    0x34(%ebx),%eax
     398:	8d 4b 34             	lea    0x34(%ebx),%ecx
     39b:	8b 51 04             	mov    0x4(%ecx),%edx
     39e:	85 c0                	test   %eax,%eax
     3a0:	89 02                	mov    %eax,(%edx)
     3a2:	74 03                	je     3a7 <death_by_timeout+0x57>
     3a4:	89 50 04             	mov    %edx,0x4(%eax)
     3a7:	c7 41 04 00 02 20 00 	movl   $0x200200,0x4(%ecx)	// LIST_POISON2

     3ae:	89 d8                	mov    %ebx,%eax
     3b0:	e8 fc ff ff ff       	call   <nf_ct_remove_expectations>

     3b5:	b8 00 00 00 00       	mov    <nf_conntrack_lock>,%eax
     3ba:	e8 fc ff ff ff       	call   <_spin_unlock_bh>

     3bf:	85 db                	test   %ebx,%ebx
     3c1:	74 77                	je     43a <death_by_timeout+0xea>
     3c3:	ff 0b                	decl   (%ebx)
     3c5:	0f 94 c0             	sete   %al
     3c8:	84 c0                	test   %al,%al
     3ca:	74 07                	je     3d3 <death_by_timeout+0x83>
     3cc:	89 d8                	mov    %ebx,%eax
     3ce:	e8 fc ff ff ff       	call   <nf_conntrack_destroy>
     3d3:	83 c4 0c             	add    $0xc,%esp
     3d6:	5b                   	pop    %ebx
     3d7:	5e                   	pop    %esi
     3d8:	5d                   	pop    %ebp
     3d9:	c3                   	ret    

     3da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     3e0:	0f b6 c0             	movzbl %al,%eax
     3e3:	89 d6                	mov    %edx,%esi
     3e5:	01 c6                	add    %eax,%esi
     3e7:	74 83                	je     36c <death_by_timeout+0x1c>
     3e9:	b8 e9 03 00 00       	mov    $0x3e9,%eax
     3ee:	31 c9                	xor    %ecx,%ecx
     3f0:	89 44 24 08          	mov    %eax,0x8(%esp)
     3f4:	b8 01 00 00 00       	mov    $0x1,%eax
     3f9:	31 d2                	xor    %edx,%edx
     3fb:	89 44 24 04          	mov    %eax,0x4(%esp)
     3ff:	b8 00 00 00 00       	mov    <rcu_lock_map>,%eax
     404:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     40b:	e8 fc ff ff ff       	call   <lock_acquire>
     410:	8b 06                	mov    (%esi),%eax
     412:	85 c0                	test   %eax,%eax
     414:	74 0b                	je     421 <death_by_timeout+0xd1>
     416:	8b 50 40             	mov    0x40(%eax),%edx
     419:	85 d2                	test   %edx,%edx
     41b:	74 04                	je     421 <death_by_timeout+0xd1>
     41d:	89 d8                	mov    %ebx,%eax
     41f:	ff d2                	call   *%edx
     421:	b9 21 04 00 00       	mov    $0x421,%ecx
     426:	ba 01 00 00 00       	mov    $0x1,%edx
     42b:	b8 00 00 00 00       	mov    <rcu_lock_map>,%eax
     430:	e8 fc ff ff ff       	call   <lock_release>
     435:	e9 32 ff ff ff       	jmp    36c <death_by_timeout+0x1c>
     43a:	ba b2 00 00 00       	mov    $0xb2,%edx
     43f:	b8 00 00 00 00       	mov    $0x0,%eax
     444:	e8 fc ff ff ff       	call   <warn_on_slowpath>
     449:	eb 88                	jmp    3d3 <death_by_timeout+0x83>
     44b:	90                   	nop    
     44c:	8d 74 26 00          	lea    0x0(%esi),%esi

--76DTJ5CE0DCVQemd--
