From: sat <satendrasahu1990@gmail.com>
Subject: how to receive arp packet from queue to application
Date: Fri, 30 Oct 2015 13:36:19 +0000 (UTC)
Message-ID: <loom.20151030T143425-274@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39402 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030658AbbJ3NkG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Oct 2015 09:40:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gnnd-netfilter-devel@m.gmane.org>)
	id 1Zs9uV-0006LJ-6X
	for netfilter-devel@vger.kernel.org; Fri, 30 Oct 2015 14:40:03 +0100
Received: from 14.141.44.158.Static-Bangalore.tcl.net.in ([14.141.44.158.Static-Bangalore.tcl.net.in])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Oct 2015 14:40:03 +0100
Received: from satendrasahu1990 by 14.141.44.158.Static-Bangalore.tcl.net.in with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Oct 2015 14:40:03 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I have added rule in nftables which will filter ARP packets. I am 
sending packet in queue but I am not able receive these packets in our 
application but using same application I can receive IP packet. 
Application which I am using.

main()
{
   int fd;
   char buf[65535];
   int len=0;
   handle =nfq_open();

   if(handle ==NULL)
    {
     printf("error in nfq_open\n");
     return 1;
    }

  if(nfq_unbind_pf(handle,AF_INET)<0)
    {
       printf("error during nfq_unbind_pf\n");
       exit(1);
    }

  if(nfq_bind_pf(handle,AF_INET)<0)
   {
      printf("error in binding\n");
      exit(1);
   }

  qh=nfq_create_queue(handle,0,&callback,NULL);

  if(qh==NULL)
  {
     printf("error to create new queue\n");
     exit(1);
  }


  if(nfq_set_mode(qh,NFQNL_COPY_PACKET,0xffff)<0)
  {
     printf("error to set mode \n");
     exit(1);
  }

  if(nfq_set_queue_maxlen(qh,NFQ_MAX_LEN)<0)
  {
     printf("error setting queue size\n");
  }

  fd =nfq_fd(handle);

  if(fd== (-1))
  {
   printf("error in opening nft queue\n");
   exit(1);
  }

  while(1)
  {
    len = recv(fd, buf, sizeof(buf), 0);
    printf("pkt received in main thread buf: %s length :%d\n",buf,len);

  nfq_destroy_queue(qh);

  printf("closing library handle\n");
  nfq_close(handle); /* closing the handler */

}

