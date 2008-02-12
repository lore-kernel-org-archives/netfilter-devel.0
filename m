From: Arthur Ulfeldt <arthur@untangle.com>
Subject: Valgrind warnings in libnetfilter_queue about pointers to
 uninitialsed bytes
Date: Tue, 12 Feb 2008 13:32:11 -0800 (PST)
Message-ID: <14627619.43021202851931588.JavaMail.root@zimbra.untangle.com>
References: <26584120.42901202851726239.JavaMail.root@zimbra.untangle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from host57.untangle.com ([198.144.196.57]:38137 "EHLO
	zimbra.untangle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbYBLVlG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Feb 2008 16:41:06 -0500
Received: from localhost (localhost [127.0.0.1])
	by zimbra.untangle.com (Postfix) with ESMTP id 903D310383BA
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Feb 2008 13:32:12 -0800 (PST)
Received: from zimbra.untangle.com ([127.0.0.1])
	by localhost (zimbra.untangle.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id u2+38VfPusiX for <netfilter-devel@vger.kernel.org>;
	Tue, 12 Feb 2008 13:32:12 -0800 (PST)
Received: from zimbra.untangle.com (zimbra.untangle.com [127.0.1.1])
	by zimbra.untangle.com (Postfix) with ESMTP id F09121038131
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Feb 2008 13:32:11 -0800 (PST)
In-Reply-To: <26584120.42901202851726239.JavaMail.root@zimbra.untangle.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Valgrind is reporting uninitialised bytes at the pointer returned by nfq_open().
libnetfilter_queue version 1.1.0.

/* initialize the netfilter queue */
if (( _queue.nfq_h = nfq_open()) == NULL ) return perrlog( "nfq_open" );
 
/* Unbind any existing queue handlers */
/* In > 2.6.22, EINVAL is returned if the queue handler isn't register.  So
   we just ignore it. */
if ( nfq_unbind_pf( _queue.nfq_h, PF_INET ) < 0 && errno != EINVAL ) return perrlog( "nfq_unbind_pf" );
    ==20443== Syscall param ! points to uninitialised byte(s)
    ==20443==    at 0x4030B4E: sendmsg (in /lib/tls/libpthread-0.60.so)
    ==20443==    by 0x28659EF4: (within /usr/lib/libnetfilter_queue.so.1.1.0)
    ==20443==    by 0x2865A167: nfq_unbind_pf (in /usr/lib/libnetfilter_queue.so.1.1.0)

/* Bind queue */
if ( nfq_bind_pf( _queue.nfq_h, PF_INET ) < 0 ) return perrlog( "nfq_bind_pf" );
    ==20443== Syscall param ! points to uninitialised byte(s)
    ==20443==    at 0x4030B4E: sendmsg (in /lib/tls/libpthread-0.60.so)
    ==20443==    by 0x28659EF4: (within /usr/lib/libnetfilter_queue.so.1.1.0)
    ==20443==    by 0x2865A1FA: nfq_create_queue (in /usr/lib/libnetfilter_queue.so.1.1.0)

/* Bind the socket to a queue */
   if (( _queue.nfq_qh = nfq_create_queue( _queue.nfq_h,  0, &_nf_callback, NULL )) == NULL ) {
      return perrlog( "nfq_create_queue" );
   }
        
....
/* Cleanup */    
/* close the queue handler */
if (( _queue.nfq_qh != NULL ) && ( nfq_destroy_queue( _queue.nfq_qh ) < 0 )) {
    perrlog( "nfq_destroy_queue" );
}
    ==20443== Syscall param <DD><DD><DD><DD><DD><DD><DD><DD><DD><DD><DD><DD><DD><DD>
    <DD><DD><DD><DD><DD><DD><DD><DD><DD><DD><DD><DD><DD><DD><DD><DD><DD><DD><DD><DD>
    <DD><DD><DD><DD><DD><DD> points to uninitialised byte(s)
    ==20443==    at 0x4030B4E: sendmsg (in /lib/tls/libpthread-0.60.so)
    ==20443==    by 0x28659EF4: (within /usr/lib/libnetfilter_queue.so.1.1.0)
    ==20443==    by 0x2865A26E: nfq_destroy_queue (in /usr/lib/libnetfilter_queue.so
    .1.1.0)
